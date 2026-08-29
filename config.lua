Config = {
    Enabled = true,
    CheckOnStart = true,
    StartupDelaySeconds = 15,
    IntervalMinutes = 720,
    ResponseDeadlineSeconds = 15,
    CacheTtlMinutes = 120,
    ManualRefreshCooldownSeconds = 60,
    MaxBackoffMinutes = 240,
    JitterPercent = 10,
    MaxConcurrentRequests = 2,
    MaxResponseBytes = 1048576,
    MaxReleases = 50,
    MaxReleaseTitleBytes = 160,
    ReportCurrent = false,
    ReportSummary = true,
    IncludeReleaseTitle = true,
    ReportNewerThanPin = false,
    AllowManifestDiscovery = false,
    AllowedOwners = { 'FeatherFramework' },
    CacheFile = 'versioner-cache.json',
    Resources = {
        ['feather-core'] = {
            repository = 'FeatherFramework/feather-core',
            channel = 'stable'
        },
        ['feather-character'] = {
            repository = 'FeatherFramework/feather-character',
            channel = 'stable'
        },
        ['feather-weapons'] = {
            repository = 'FeatherFramework/feather-weapons',
            channel = 'stable'
        },
        ['feather-admin'] = {
            repository = 'FeatherFramework/feather-admin',
            channel = 'stable'
        },
        ['feather-inventory'] = {
            repository = 'FeatherFramework/feather-inventory',
            channel = 'stable'
        },
        ['feather-hud'] = {
            repository = 'FeatherFramework/feather-hud',
            channel = 'stable'
        },
    }
}
