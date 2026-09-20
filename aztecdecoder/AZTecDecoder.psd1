@{
    RootModule        = 'AZTecDecoder.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'f99a2d69-d6e2-46cf-8992-f2d67c9ea8f0'
    Author            = 'Bartosz Wójcik'
    CompanyName       = 'PELock'
    Copyright         = '(c) 2026 Bartosz Wójcik / PELock. All rights reserved.'
    Description       = 'PowerShell Gallery Web API client for AZTecDecoder. Decode AZTEC 2D codes from Polish vehicle registration certificates.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @(
        'New-AZTecDecoder'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags         = @(
                'AZTEC',
                'Decoder',
                'Registration',
                'Poland',
                'PELock',
                'API'
            )
            LicenseUri   = 'https://www.apache.org/licenses/LICENSE-2.0'
            ProjectUri   = 'https://www.pelock.com/pl/produkty/dekoder-aztec'
            ReleaseNotes = @'
## 1.0.0

- Initial PowerShell Gallery release
- AZTecDecoder class — decode-text and decode-image
- Empty activation key allowed for demo use
- New-AZTecDecoder — factory for the client
'@
        }
    }
}
