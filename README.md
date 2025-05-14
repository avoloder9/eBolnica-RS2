# eBolnica-RS2
Seminarski rad iz predmeta Razvoj softvera II

<h1>Upute za pokretanje</h1>
<h2>Nakon kloniranja repozitorija uraditi sljedeće:</h2>
<ul>
    <li><strong style="font-size: 1.2em;">Extractovati: fit-build-2025-05-13-env</strong></li>
    <li><strong style="font-size: 1.2em;">Postaviti .env fajl u: \eBolnica-RS2\eBolnica</strong></li>
    <li><strong style="font-size: 1.2em;">Otvoriti \eBolnica-RS2\eBolnica u terminalu i pokrenuti komandu: docker-compose up --build</strong></li>
</ul>
<ul>
    <li><strong style="font-size: 1.2em;">Extractovati: fit-build-2025-05-13-desktop</strong></li>
    <li><strong style="font-size: 1.2em;">Pokrenuti ebolnica_desktop.exe koji se nalazi u folderu "Release"</strong></li>
    <li><strong style="font-size: 1.2em;">Unijeti desktop kredencijale koji se mogu pronaći u ovom readme-u</strong></li>
</ul>

<ul>
    <li><strong style="font-size: 1.2em;">Prije pokretanja mobilne aplikacije pobrinuti se da aplikacija već ne postoji na android emulatoru, ukoliko postoji, uraditi deinstalaciju iste</strong></li>
    <li><strong style="font-size: 1.2em;">Extractovati: fit-build-2025-05-13-mobile</strong></li>
    <li><strong style="font-size: 1.2em;">Nakon extractovanja, prevući apk fajl koji se nalazi u folderu "flutter-apk" i sačekati da se aplikacija instalira</strong></li>
    <li><strong style="font-size: 1.2em;">Nakon što je aplikacija instalirana, pokrenuti je i unijeti mobilne kredencijale koji se mogu pronaći u ovom readme-u </strong></li>
</ul>

<h1>Napomene</h1>
<ul>
    <li>
        Nakon dodavanja ili registracije novog pacijenta, potrebno je kreirati medicinsku dokumentaciju kako bi se mogao obaviti pregled. 
        <span style="font-weight: 500; color: #2c3e50;">Medicinsko osoblje je zaduženo za kreiranje dokumentacije.</span>
    </li>
    <li>
        <span style="font-weight: 500; color: #2c3e50;">
            Za prikaz rasporeda smjena potrebno je <b>generisati raspored</b> od strane Administratora.
        </span>
    </li>    
    <li>
        <span style="font-weight: 500; color: #2c3e50;">
            Radni zadatak je moguće kreirati samo za osoblje odjela na kojem je doktor zaposlen i koje je trenutno na smjeni i za pacijente koji su hospitalizovani na tom odjelu.
        </span>
    </li>
    <li>
        <span style="font-weight: 500; color: #2c3e50;">
            Zahtjev za slobodan dan se šalje Administratoru koji to odobrava ili odbija, a osoblje dobija obavijest putem e-maila.
        </span>
    </li>
    <li>
        <span style="font-weight: 500; color: #2c3e50;">
            Sve notifikacije unutar aplikacije se šalju <b> isključivo putem e-maila.</b>
        </span>
    </li>
</ul>

<h1>Kredencijali za prijavu</h1>
<h2>Desktop aplikacija</h2>
<h2><strong>Administrator</strong></h2>
<ul>
    <li><strong style="font-size: 1.2em;">Korisničko ime:</strong> admin</li>
    <li><strong style="font-size: 1.2em;">Lozinka:</strong> Admin123!</li>
</ul>
<h2><strong>Doktor 1</strong></h2>
<ul>
    <li><strong style="font-size: 1.2em;">Korisničko ime:</strong> doktor</li>
    <li><strong style="font-size: 1.2em;">Lozinka:</strong> Doktor123!</li>
</ul>
<h2><strong>Doktor 2</strong></h2>
<ul>
    <li><strong style="font-size: 1.2em;">Korisničko ime:</strong> hirurg</li>
    <li><strong style="font-size: 1.2em;">Lozinka:</strong> Doktor123!</li>
</ul>
<h2><strong>Medicinsko osoblje</strong></h2>
<ul>
    <li><strong style="font-size: 1.2em;">Korisničko ime:</strong> osoblje</li>
    <li><strong style="font-size: 1.2em;">Lozinka:</strong> Osoblje123!</li>
</ul>
<h2><strong>Pacijent</strong></h2>
<ul>
    <li><strong style="font-size: 1.2em;">Korisničko ime:</strong> pacijent</li>
    <li><strong style="font-size: 1.2em;">Lozinka:</strong> Pacijent123!</li>
</ul>
<h2>Mobilna aplikacija</h2>
<h2><strong>Pacijent</strong></h2>
<ul>
    <li><strong style="font-size: 1.2em;">Korisničko ime:</strong> pacijent</li>
    <li><strong style="font-size: 1.2em;">Lozinka:</strong> Pacijent123!</li>
</ul>
<h2><strong>Medicinsko osoblje</strong></h2>
<ul>
    <li><strong style="font-size: 1.2em;">Korisničko ime:</strong> osoblje</li>
    <li><strong style="font-size: 1.2em;">Lozinka:</strong> Osoblje123!</li>
</ul>
<h2><strong>Doktor</strong></h2>
<ul>
    <li><strong style="font-size: 1.2em;">Korisničko ime:</strong> doktor</li>
    <li><strong style="font-size: 1.2em;">Lozinka:</strong> Doktor123!</li>
</ul>

<body>
    <h1>RabbitMQ</h1>
    <ul>
        <li><strong>RabbitMQ</strong> je korišten za slanje mailova pacijentima nakon zakazivanja/otkazivanja termina, kao i za slanje povratnih informacija o slobodnim danima osoblja.</li>
    </ul>
</body>
<hr>
<body>
