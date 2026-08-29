# Feather Versioner

Feather Versioner is an optional, server-only release notification service. It compares installed resource manifest versions with operator-selected GitHub release policies and prints concise console reports.

It does not download, overwrite, start, stop, restart, or migrate anything. GitHub availability never controls framework readiness, and Versioner does not replace runtime contract negotiation.

## Installation

Place `feather-versioner` in the server resources directory, configure explicit repository mappings in `config.lua`, and add:

```cfg
ensure feather-versioner
```

It may start before or after checked resources. A configured resource that is missing, stopped, or has invalid manifest version metadata is reported as unknown and is never modified.

## Configuration

Outbound checks are disabled per resource until the operator adds it to `Config.Resources`:

```lua
Config.Resources = {
    ['feather-core'] = {
        repository = 'FeatherFramework/feather-core',
        channel = 'stable'
    },
    ['my-fork'] = {
        repository = 'MyServer/my-fork',
        channel = 'prerelease',
        pin = '1.4.2',
        ignore = { '1.5.0' },
        label = 'My Fork'
    }
}
```

`AllowedOwners` is an outbound GitHub owner allowlist. Repository identities are validated and converted internally into GitHub API URLs; arbitrary URLs are never accepted. Manifest discovery is reserved for a later release and remains disabled.

Stable checks exclude drafts and prereleases. The prerelease channel includes both stable and prerelease releases and selects the newest valid SemVer. Ignored versions are removed from target selection. A pin becomes the operator target: an exact match is `pinned`, a lower installation is `outdated`, and a higher installation is `ahead`.

Versions must use strict `major.minor.patch` SemVer. A leading `v` is accepted on release tags. Build metadata is retained for display but does not affect precedence.

## Commands

Server console only:

```text
feather versions
feather versions check
feather versions <resource>
feather versions help
```

Manual checks respect `ManualRefreshCooldownSeconds`. Periodic checks use jitter, bounded concurrency, ETags, response deadlines, retry backoff, and stale-cache fallback.

## Cache and outages

Versioner writes only `versioner-cache.json` and its backup inside its own resource. Corrupt cache data is ignored. A valid backup is used when the primary file cannot be decoded. Network failures retain a previously valid cached release as stale and never block other resources.

## Verification

Run these from the server console:

```text
VersionerContractSmokeTest
VersionerSemverSmokeTest
VersionerFixtureSmokeTest
```

After configuring at least one repository, run `feather versions check` to exercise the live GitHub path.

## Migration

Release deployment remains manual and operator-controlled. Remove legacy `github_version_check` manifest metadata only after a resource is mapped to a published Versioner release policy. Runtime consumers must continue using capability and contract negotiation rather than release versions.
