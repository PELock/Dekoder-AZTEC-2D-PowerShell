# Dekoder Kodu AZTEC 2D z Dowodu Rejestracyjnego dla PowerShell

Oferujemy Państwu usługę Web API pozwalającą zdekodować dane z kodu AZTEC 2D zapisanego w dowodach rejestracyjnych pojazdów samochodowych.

![Kod AZTEC 2D zapisany w formie obrazkowej w dowodzie rejestracyjnym pojazdu](https://www.pelock.com/img/pl/produkty/dekoder-aztec/dowod-rejestracyjny-kod-aztec-2d.jpg)

Nasza biblioteka dekoduje dane z dowodu rejestracyjnego, zapisane w postaci kodu obrazkowego tzw. kod aztec. Dekodowane są wszystkie wymienione pola w dowodzie rejestracyjnym pojazdu.

https://www.pelock.com/pl/produkty/dekoder-aztec

## Gdzie znajdzie zastosowanie Dekoder AZTec?

Dekoder AZTec może przydać się firmom i instytucjom, które pragną zautomatyzować proces ręcznego wprowadzania danych z dowodów rejestracyjnych i zastąpić go poprzez wykorzystanie naszej biblioteki programistycznej, która potrafi rozpoznać i rozkodowac kody AZTEC 2D bezpośrednio ze zdjęć dowodów rejestracyjnych lub zeskanowanych już kodów (wykorzystując skaner QR / AZTEC 2D).

## Dostępne edycje programistyczne

Dekoder AZTec dostepny jest w trzech edycjach. Każda wersja posiada inne cechy i inne możliwości dekodowania. Wersja oparta o Web API jako jedyna posiada możliwość rozpoznawania i dekodowania danych bezpośrednio ze zdjęć i obrazków. Pozostałe wersje do dekodowania wymagają już odczytanego kodu w postaci tekstu (np. ze skanera).

![Dekodowanie kodu AZTEC 2D do formatu JSON](https://www.pelock.com/img/pl/produkty/dekoder-aztec/dekodowanie-kodu-aztec-2d-do-json.png)

### Wersja Web API

Jest to najbardziej zaawansowana edycja Dekodera AZTec, ponieważ umożliwia precyzyjne rozpoznawanie i dekodowanie kodów AZTEC 2D bezpośrednio ze zdjęć oraz obrazków zapisanych w formatach PNG lub JPG.

Algorytm rozpoznawania obrazu należy do naszej firmy, jest to innowacyjne rozwiązanie rozwijane od podstaw przez prawie rok czasu.

Rozumiemy potrzeby naszych klientów oraz problemy wynikające z rozpoznawnia rzeczywistych zdjęć kodów AZTEC 2D znajdujących się w dowodach rejestracyjnych, które nie zawsze są idealnie wykonane, czy to ze względu na rodzaj aparatu, kąta wykonania zdjęcia, refleksów czy słabej rozdzielczości.

Przy tworzeniu naszego rozwiązania wzieliśmy wszystkie te czynniki pod uwagę i w efekcie nasz algorytm radzi sobie znakomicie z rozpoznawaniem kodów AZTEC 2D ze zdjęć z wszelkiego rodzaju zniekształceniami, uszkodzeniami i niedoskonałościami. Znacznie przewyższa pod względem funkcjonowania dostępne na rynku biblioteki rozpoznawnia kodów AZTEC 2D takie jak np. ZXing.

### Gotowe paczki dla różnych języków programowania

Dla ułatwienia szybkiego wdrożenia, paczki instalacyjne Dekodera AZTec zostały wgrane na repozytoria dla kilku popularnych języków programowania, a dodatkowo ich kody źródłowe zostały opublikowane na GitHubie:

| Repozytorium | Język | Instalacja | Paczka | GitHub |
| ------------ | ----- | ---------- | ------ | ------ |
| ![Centralne Repozytorium Maven](https://www.pelock.com/img/logos/repo-maven.png) | Java | Dodaj wpis do pliku `pom.xml`<br />`<dependency>`<br />`  <groupId>com.pelock</groupId>`<br />`  <artifactId>AZTecDecoder</artifactId>`<br />`  <version>1.0.0</version>`<br />`</dependency>` | [Maven](https://search.maven.org/#search%7Cga%7C1%7Cg%3A%22com.pelock%22) | [Źródła](https://github.com/PELock/Dekoder-AZTEC-2D-Java)
| ![Repozytorium NPM](https://www.pelock.com//img/logos/repo-npm.png) | JavaScript, TypeScript | `npm install aztec-decoder` | [NPM](https://www.npmjs.com/package/aztec-decoder) | [Źródła](https://github.com/PELock/Dekoder-AZTEC-2D-JavaScript)
| ![Repozytorium NuGet](https://www.pelock.com/img/logos/repo-nuget.png) | C#, VB.NET, .NET | `PM> Install-Package AZTecDecoder` | [NuGet](https://www.nuget.org/packages/AZTecDecoder/) | [Źródła](https://github.com/PELock/Dekoder-AZTEC-2D-CSharp)
| ![Repozytorium Packagist dla Composer](https://www.pelock.com/img/logos/repo-packagist-composer.png) | PHP | Dodaj do sekcji `require` w twoim pliku `composer.json` linijkę `"pelock/aztec-decoder": "*"` | [Packagist](https://packagist.org/packages/pelock/aztec-decoder) | [Źródła](https://github.com/PELock/Dekoder-AZTEC-2D-PHP)
| ![Repozytorium PyPI dla Python](https://www.pelock.com/img/logos/repo-pypi.png) | Python | `pip install aztecdecoder` | [PyPi](https://pypi.org/project/aztecdecoder/) | [Źródła](https://github.com/PELock/Dekoder-AZTEC-2D-Python)

#### Instalacja

The preferred way to install the Web API SDK is via PowerShell Gallery.

```powershell
Install-Module -Name AZTecDecoder
Import-Module AZTecDecoder
```

Module listing: https://www.powershellgallery.com/packages/AZTecDecoder

## Usage examples

### Example — `AZTecDecoderDecodeImage.ps1`

```powershell
################################################################################
#
# AZTecDecoder WebApi interface usage example.
#
# Decode an AZTEC 2D code from a PNG/JPG photo (multipart upload).
# An empty key is allowed for demo use.
#
# Version        : v1.0.0
# Language       : PowerShell
# Author         : Bartosz Wójcik
# Web page       : https://www.pelock.com
#
################################################################################

using module '..\aztecdecoder\AZTecDecoder.psd1'

$client = New-AZTecDecoder -ApiKey 'ABCD-ABCD-ABCD-ABCD'
$result = $client.DecodeImageFromFile('registration.jpg')

if ($result) {
    $result | ConvertTo-Json -Depth 6
}
else {
    Write-Host 'Something unexpected happen while trying to decode the image.'
}
```

### Example — `AZTecDecoderDecodeText.ps1`

```powershell
################################################################################
#
# AZTecDecoder WebApi interface usage example.
#
# Decode an already scanned AZTEC 2D value (ASCII text).
#
# Version        : v1.0.0
# Language       : PowerShell
# Author         : Bartosz Wójcik
# Web page       : https://www.pelock.com
#
################################################################################

using module '..\aztecdecoder\AZTecDecoder.psd1'

$client = New-AZTecDecoder -ApiKey 'ABCD-ABCD-ABCD-ABCD'
$result = $client.DecodeText('AAABBBCCC...')

if ($result) {
    $result | ConvertTo-Json -Depth 6
}
else {
    Write-Host 'Something unexpected happen while trying to decode the text.'
}
```

See the `examples/` directory in this repository for complete samples.

Bartosz Wójcik
https://www.pelock.com | https://www.dekoderaztec.pl