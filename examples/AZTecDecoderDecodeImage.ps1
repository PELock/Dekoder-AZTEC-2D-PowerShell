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
