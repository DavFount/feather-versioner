VersionerCache = { entries = {}, dirty = false }
local resourceName = GetCurrentResourceName()

local function validEntry(key, value)
    return type(key) == 'string' and type(value) == 'table' and type(value.fetchedAt) == 'number'
        and type(value.expiresAt) == 'number' and type(value.releases) == 'table'
end

function VersionerCache.Load()
    VersionerCache.entries = {}
    local raw = LoadResourceFile(resourceName, Config.CacheFile)
    if not raw or raw == '' then return VersionerResults.Ok({ loaded = 0 }) end
    if #raw > Config.MaxResponseBytes then return VersionerResults.Err('cache_invalid', 'Cache file exceeds its size limit.') end
    local ok, decoded = pcall(json.decode, raw)
    if not ok or type(decoded) ~= 'table' or type(decoded.entries) ~= 'table' then
        raw = LoadResourceFile(resourceName, Config.CacheFile .. '.bak')
        if not raw or #raw > Config.MaxResponseBytes then return VersionerResults.Err('cache_invalid', 'Cache file is corrupt.') end
        ok, decoded = pcall(json.decode, raw)
        if not ok or type(decoded) ~= 'table' or type(decoded.entries) ~= 'table' then return VersionerResults.Err('cache_invalid', 'Cache and backup files are corrupt.') end
    end
    local count = 0
    for key, value in pairs(decoded.entries) do if validEntry(key, value) then VersionerCache.entries[key] = value; count = count + 1 end end
    return VersionerResults.Ok({ loaded = count })
end

function VersionerCache.Save()
    local payload = json.encode({ schema = 1, writtenAt = os.time(), entries = VersionerCache.entries })
    if #payload > Config.MaxResponseBytes then return VersionerResults.Err('cache_too_large', 'Cache payload exceeds its size limit.') end
    local existing = LoadResourceFile(resourceName, Config.CacheFile)
    if existing and existing ~= '' then SaveResourceFile(resourceName, Config.CacheFile .. '.bak', existing, #existing) end
    local saved = SaveResourceFile(resourceName, Config.CacheFile, payload, #payload)
    if saved == false then return VersionerResults.Err('cache_write_failed', 'Cache file could not be written.') end
    VersionerCache.dirty = false
    return VersionerResults.Ok({ bytes = #payload })
end

function VersionerCache.Get(key) return VersionerCache.entries[key] end
function VersionerCache.IsFresh(entry, now) return entry and tonumber(entry.expiresAt) and entry.expiresAt > (now or os.time()) end
function VersionerCache.Put(key, value) VersionerCache.entries[key] = value; VersionerCache.dirty = true end
