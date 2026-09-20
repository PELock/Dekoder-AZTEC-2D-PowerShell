# Dekoder AZTEC 2D — PowerShell SDK

**[AZTecDecoder](https://www.pelock.com/pl/produkty/dekoder-aztec)** decodes AZTEC 2D codes from Polish vehicle registration certificates.

API: https://www.pelock.com/api/aztec-decoder/v1  
Site: https://www.dekoderaztec.pl

## Installation

```powershell
Install-Module -Name AZTecDecoder
```

or

```powershell
Install-PSResource -Name AZTecDecoder
```

```powershell
using module AZTecDecoder
# or:
Import-Module AZTecDecoder
$client = New-AZTecDecoder -ApiKey 'ABCD-ABCD-ABCD-ABCD'
```

An empty key is allowed for demo use (unlike the old PHP SDK).

## Usage

```powershell
using module AZTecDecoder

$client = New-AZTecDecoder -ApiKey 'ABCD-ABCD-ABCD-ABCD'
$fromImage = $client.DecodeImageFromFile('registration.jpg')
$fromText = $client.DecodeText($aztecAscii)
```

`DecodeImageFromFile` sends the image as a multipart file. See `examples/`.

Author: Bartosz Wójcik / PELock — https://www.pelock.com
