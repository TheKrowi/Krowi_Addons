-- [[ Exported at 2021-07-05 22-45-28 ]] --
-- [[ This code is automatically generated as an export from ]] --
-- [[ an SQLite database and is not meant for manual edit. ]] --

-- [[ Namespaces ]] --
local _, addon = ...;
local data = addon.Data;
data.NextPatch = {};
local nextPatch = data.NextPatch;

function nextPatch.Load(achievements)
    for i, _ in next, achievements do
        achievements[i] = nil;
    end

end

