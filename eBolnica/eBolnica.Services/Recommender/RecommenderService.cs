using eBolnica.Model.Response;
using eBolnica.Services.Database;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.EntityFrameworkCore;

namespace eBolnica.Services.Recommender
{
    public class RecommenderService : IRecommenderService
    {
        private static MLContext _mlContext = null!;
        private static object _isLocked = new object();
        private static ITransformer _model = null!;
        private const string ModelFilePath = "doktor-model.zip";

        private readonly EBolnicaContext Context;

        public RecommenderService(EBolnicaContext context)
        {
            Context = context;
        }
        public void TrainModel()
        {
            lock (_isLocked)
            {
                if (_mlContext == null)
                {
                    _mlContext = new MLContext();
                }
                if (File.Exists(ModelFilePath))
                {
                    using (var stream = new FileStream(ModelFilePath, FileMode.Open, FileAccess.Read, FileShare.Read))
                    {
                        _model = _mlContext.Model.Load(stream, out var _);
                    }
                }
                else
                {
                    var termini = Context.Termins.ToList();
                    var obavljeniPregledi = Context.Pregleds.Where(p => p.Uputnica.Termin.PacijentId == p.Uputnica.Termin.PacijentId && p.Uputnica.StateMachine == "closed")
                     .Include(p => p.Uputnica).ThenInclude(u => u.Termin).ToList();
                    var data = termini.Select(t => new DoktorPacijentInteraction
                    {
                        PacijentId = (uint)t.PacijentId,
                        DoktorId = (uint)t.DoktorId,
                        Label = obavljeniPregledi.Any(p => p.Uputnica.Termin.DoktorId == t.DoktorId) ? 1f : 0f 
                    }).ToList();

                    var trainingData = _mlContext.Data.LoadFromEnumerable(data);
                    var options = new Microsoft.ML.Trainers.MatrixFactorizationTrainer.Options
                    {
                        MatrixColumnIndexColumnName = nameof(DoktorPacijentInteraction.PacijentId),
                        MatrixRowIndexColumnName = nameof(DoktorPacijentInteraction.DoktorId),
                        LabelColumnName = nameof(DoktorPacijentInteraction.Label),
                        LossFunction = Microsoft.ML.Trainers.MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                        Alpha = 0.01f,
                        Lambda = 0.025f,
                        NumberOfIterations = 100,
                        ApproximationRank = 100
                    };

                    var est = _mlContext.Recommendation().Trainers.MatrixFactorization(options);
                    _model = est.Fit(trainingData);
                    using (var stream = new FileStream(ModelFilePath, FileMode.Create, FileAccess.Write, FileShare.Write))
                    {
                        _mlContext.Model.Save(_model, trainingData.Schema, stream);
                    }
                }
            }
        }
        public List<Model.Models.Doktor> GetPreporuceniDoktori(int pacijentId, int brojPreporuka = 3)
        {
            var doktori = Context.Doktors.Include(d => d.Korisnik).ToList();
            var obavljeniPregledi = Context.Pregleds
                .Where(p => p.Uputnica.Termin.PacijentId == pacijentId && p.Uputnica.StateMachine == "closed")
                .Include(p => p.Uputnica).ThenInclude(u => u.Termin).ToList();

            var obavljeniDoktori = obavljeniPregledi.Select(p => p.Uputnica.Termin.Doktor).Distinct().ToList();
            var doktoriBezPrethodnih = doktori.Where(d => !obavljeniDoktori.Any(od => od.DoktorId == d.DoktorId)).ToList();
            var zakazaniPregledi = Context.Uputnicas
                .Where(u => u.Termin.PacijentId == pacijentId &&
                            (u.StateMachine != "closed" || u.Termin == null))
                .Include(u => u.Termin)
                .Select(u => u.Termin.Doktor)
                .Distinct()
                .ToList();

            var doktoriZaPreporuku = doktoriBezPrethodnih.Concat(zakazaniPregledi).Distinct().ToList();
            if (!obavljeniDoktori.Any() && !zakazaniPregledi.Any())
            {
                return doktoriZaPreporuku.Take(brojPreporuka).Select(d => new Model.Models.Doktor
                {
                    DoktorId = d.DoktorId,
                    Korisnik = new Model.Models.Korisnik
                    {
                        Ime = d.Korisnik.Ime,
                        Prezime = d.Korisnik.Prezime,
                        KorisnikId = d.Korisnik.KorisnikId,
                        DatumRodjenja = d.Korisnik.DatumRodjenja,
                        Telefon = d.Korisnik.Telefon,
                        Slika = d.Korisnik.Slika
                    },
                    Specijalizacija = d.Specijalizacija,
                    Biografija = d.Biografija!
                }).ToList();
            }

            var doktorTextData = doktoriZaPreporuku.Select(d => new
            {
                Doktor = d,
                Text = $"{d.Specijalizacija} {d.Biografija}"
            }).ToList();

            var pacijentProfilTekst = string.Join(" ", obavljeniPregledi.Select(p => $"{p.Uputnica.Termin.Doktor.Specijalizacija} {p.Uputnica.Termin.Doktor.Biografija}"));

            var mlContext = new MLContext();
            var podaci = doktorTextData.Select(d => new DoktorText { Text = d.Text }).ToList();
            podaci.Add(new DoktorText { Text = pacijentProfilTekst });

            var dataView = mlContext.Data.LoadFromEnumerable(podaci);

            var pipeline = mlContext.Transforms.Text.FeaturizeText(outputColumnName: "Features", inputColumnName: nameof(DoktorText.Text));
            var transformer = pipeline.Fit(dataView);
            var transformedData = transformer.Transform(dataView);
            var featureColumn = transformedData.GetColumn<float[]>("Features").ToArray();

            var pacijentVector = featureColumn.Last();
            var doktorVectors = featureColumn.Take(featureColumn.Length - 1).ToList();

            var preporuke = doktorVectors
                .Select((v, i) => new
                {
                    Score = CosineSimilarity(pacijentVector, v),
                    Doktor = doktorTextData[i].Doktor
                })
                .OrderByDescending(x => x.Score)
                .Take(brojPreporuka)
                .Select(x => new Model.Models.Doktor
                {
                    DoktorId = x.Doktor.DoktorId,
                    Korisnik = new Model.Models.Korisnik
                    {
                        Ime = x.Doktor.Korisnik.Ime,
                        Prezime = x.Doktor.Korisnik.Prezime,
                        KorisnikId = x.Doktor.Korisnik.KorisnikId,
                        DatumRodjenja = x.Doktor.Korisnik.DatumRodjenja,
                        Telefon = x.Doktor.Korisnik.Telefon,
                        Slika = x.Doktor.Korisnik.Slika
                    },
                    Specijalizacija = x.Doktor.Specijalizacija,
                    Biografija = x.Doktor.Biografija!
                }).ToList();

            return preporuke;
        }
        public class DoktorPacijentInteraction
        {
            [KeyType(count: 1000)]
            public uint PacijentId { get; set; }

            [KeyType(count: 1000)]
            public uint DoktorId { get; set; }

            public float Label { get; set; }
        }
        public class PreporukaRezultat
        {
            public float Score { get; set; }
        }
        public class DoktorText
        {
            public string Text { get; set; } = "";
        }
        private float CosineSimilarity(float[] v1, float[] v2)
        {
            float dot = 0;
            float normA = 0;
            float normB = 0;

            for (int i = 0; i < v1.Length; i++)
            {
                dot += v1[i] * v2[i];
                normA += v1[i] * v1[i];
                normB += v2[i] * v2[i];
            }

            return dot / ((float)Math.Sqrt(normA) * (float)Math.Sqrt(normB) + 1e-5f);
        }
    }
}
