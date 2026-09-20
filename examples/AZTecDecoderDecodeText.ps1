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
