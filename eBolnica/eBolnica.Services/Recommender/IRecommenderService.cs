using eBolnica.Model.Response;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eBolnica.Services.Recommender
{
    public interface IRecommenderService
    {
        void TrainModel();
        List<RecommendedDoktorDTO> GetPreporuceniDoktori(int pacijentId, int brojPreporuka = 3);
    }
}
