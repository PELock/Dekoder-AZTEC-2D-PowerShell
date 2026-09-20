################################################################################
#
# AZTecDecoder Web API client for PowerShell.
# Decode AZTEC 2D codes from Polish vehicle registration certificates.
#
# Version      : PowerShell SDK v1.0.0
# PowerShell   : Windows PowerShell 5.1 / PowerShell 7+
# Author       : Bartosz Wójcik (support@pelock.com)
# Project      : https://www.pelock.com/pl/produkty/dekoder-aztec
# Homepage     : https://www.dekoderaztec.pl | https://www.pelock.com
#
################################################################################

Set-StrictMode -Version Latest

if ($PSVersionTable.PSVersion.Major -lt 6) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
}

$script:AztecApiUrl = 'https://www.pelock.com/api/aztec-decoder/v1'
$script:AztecUserAgent = 'PELock AZTecDecoder'
$script:AztecTimeoutSec = 3600

function ConvertTo-AztecFormBody {
    param([Parameter(Mandatory)] [hashtable]$Fields)

    $parts = foreach ($key in $Fields.Keys) {
        $name = [uri]::EscapeDataString([string]$key)
        $value = [uri]::EscapeDataString([string]$Fields[$key])
        '{0}={1}' -f $name, $value
    }

    return ($parts -join '&')
}

function Invoke-AztecMultipartRequest {
    param(
        [Parameter(Mandatory)] [hashtable]$Fields,
        [string]$FileField,
        [string]$FilePath
    )

    $headers = @{ 'User-Agent' = $script:AztecUserAgent }

    if ($PSVersionTable.PSVersion.Major -ge 6 -and $FilePath) {
        $form = @{}
        foreach ($key in $Fields.Keys) {
            $form[$key] = [string]$Fields[$key]
        }
        $form[$FileField] = Get-Item -LiteralPath $FilePath
        return Invoke-RestMethod -Uri $script:AztecApiUrl -Method Post -Form $form `
            -Headers $headers -TimeoutSec $script:AztecTimeoutSec
    }

    $boundary = '---------------------------' + [guid]::NewGuid().ToString('N')
    $encoding = [System.Text.Encoding]::UTF8
    $ms = New-Object System.IO.MemoryStream
    try {
        foreach ($key in $Fields.Keys) {
            $header = "--$boundary`r`nContent-Disposition: form-data; name=`"$key`"`r`n`r`n"
            $headerBytes = $encoding.GetBytes($header)
            $ms.Write($headerBytes, 0, $headerBytes.Length)
            $valueBytes = $encoding.GetBytes([string]$Fields[$key])
            $ms.Write($valueBytes, 0, $valueBytes.Length)
            $crlf = $encoding.GetBytes("`r`n")
            $ms.Write($crlf, 0, $crlf.Length)
        }

        if ($FilePath) {
            $fileName = [System.IO.Path]::GetFileName($FilePath)
            $fileHeader = "--$boundary`r`nContent-Disposition: form-data; name=`"$FileField`"; filename=`"$fileName`"`r`nContent-Type: application/octet-stream`r`n`r`n"
            $fileHeaderBytes = $encoding.GetBytes($fileHeader)
            $ms.Write($fileHeaderBytes, 0, $fileHeaderBytes.Length)
            $fileBytes = [System.IO.File]::ReadAllBytes((Resolve-Path -LiteralPath $FilePath).Path)
            $ms.Write($fileBytes, 0, $fileBytes.Length)
            $crlf = $encoding.GetBytes("`r`n")
            $ms.Write($crlf, 0, $crlf.Length)
        }

        $end = $encoding.GetBytes("--$boundary--`r`n")
        $ms.Write($end, 0, $end.Length)
        $body = $ms.ToArray()
    }
    finally {
        $ms.Dispose()
    }

    return Invoke-RestMethod -Uri $script:AztecApiUrl -Method Post -Body $body `
        -ContentType ("multipart/form-data; boundary={0}" -f $boundary) `
        -Headers $headers -TimeoutSec $script:AztecTimeoutSec
}

class AZTecDecoder {
    static [string] $API_URL = 'https://www.pelock.com/api/aztec-decoder/v1'

    hidden [string] $_api_key = ''

    AZTecDecoder() {
        $this.Initialize('')
    }

    AZTecDecoder([string]$ApiKey) {
        $this.Initialize($ApiKey)
    }

    hidden [void] Initialize([string]$ApiKey) {
        $this._api_key = $ApiKey
    }

    [object] DecodeText([string]$Text) {
        $params = @{
            command = 'decode-text'
            text    = $Text
        }
        return $this.PostRequest($params)
    }

    [object] decode_text([string]$text) {
        return $this.DecodeText($text)
    }

    [object] DecodeTextFromFile([string]$TextFilePath) {
        if (-not (Test-Path -LiteralPath $TextFilePath -PathType Leaf)) {
            return $null
        }

        try {
            $text = [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $TextFilePath).Path)
        }
        catch {
            return $null
        }

        if ([string]::IsNullOrEmpty($text)) {
            return $null
        }

        return $this.DecodeText($text)
    }

    [object] decode_text_from_file([string]$text_file_path) {
        return $this.DecodeTextFromFile($text_file_path)
    }

    [object] DecodeImageFromFile([string]$ImageFilePath) {
        $params = @{
            command = 'decode-image'
            image   = $ImageFilePath
        }
        return $this.PostRequest($params)
    }

    [object] decode_image_from_file([string]$image_file_path) {
        return $this.DecodeImageFromFile($image_file_path)
    }

    [object] PostRequest([hashtable]$ParamsArray) {
        # Empty key is allowed (demo / public trial), unlike the old PHP SDK.
        if ($this._api_key) {
            $ParamsArray['key'] = $this._api_key
        }

        $filePath = $null
        if ($ParamsArray.ContainsKey('image')) {
            $filePath = [string]$ParamsArray['image']
            if (-not (Test-Path -LiteralPath $filePath -PathType Leaf)) {
                return $false
            }
            $ParamsArray.Remove('image')
        }

        try {
            if ($filePath) {
                return Invoke-AztecMultipartRequest -Fields $ParamsArray -FileField 'image' -FilePath $filePath
            }

            $body = ConvertTo-AztecFormBody -Fields $ParamsArray
            $headers = @{ 'User-Agent' = $script:AztecUserAgent }
            return Invoke-RestMethod -Uri $script:AztecApiUrl -Method Post -Body $body `
                -ContentType 'application/x-www-form-urlencoded' -Headers $headers `
                -TimeoutSec $script:AztecTimeoutSec
        }
        catch {
            return $false
        }
    }

    [object] post_request([hashtable]$params_array) {
        return $this.PostRequest($params_array)
    }
}

function New-AZTecDecoder {
    <#
    .SYNOPSIS
        Creates an AZTecDecoder Web API client.

    .DESCRIPTION
        Factory for AZTecDecoder. An empty key is allowed for demo use.

    .PARAMETER ApiKey
        Activation key from PELock. Leave empty for demo mode.

    .EXAMPLE
        $client = New-AZTecDecoder -ApiKey 'ABCD-ABCD-ABCD-ABCD'
        $result = $client.DecodeImageFromFile('registration.jpg')
    #>
    [CmdletBinding()]
    [OutputType([AZTecDecoder])]
    param(
        [string]$ApiKey
    )

    if ([string]::IsNullOrWhiteSpace($ApiKey)) {
        return [AZTecDecoder]::new('')
    }

    return [AZTecDecoder]::new($ApiKey)
}

Export-ModuleMember -Function @('New-AZTecDecoder')
