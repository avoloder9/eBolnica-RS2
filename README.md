# eBolnica-RS2
Seminarski rad iz predmeta Razvoj softvera II


<h1>Upute za pokretanje</h1>
<b>Nakon kloniranja repozitorija uraditi sljedeće:</b>
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
    <li><strong style="font-size: 1em;">Nakon dodavanja ili registracije novog pacijenta potrebno je kreirati medicinsku dokumentaciju kako bi se mogao obaviti pregled. Medicinsko osoblje je zaduženo za kreiranje dokumentacije</strong></li>
    <li><strong style="font-size: 1em;">Za prikaz rasporeda smjena potrebno je generisati raspored od strane Administratora</strong></li>    
    <li><strong style="font-size: 1em;">Radni zadatak je moguće kreirati samo za osoblje odjela na kojem je doktor zaposlen</strong></li>
    <li><strong style="font-size: 1em;">Zahjev za slobodan dan se šalje administratoru koji to odobrava ili odbija, a osoblje povratnu informaciju dobija putem maila</strong></li>
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
