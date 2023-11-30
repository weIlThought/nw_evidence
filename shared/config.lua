Config = {}

Config.ESXObject = 'esx:getSharedObject' -- this is only for events gets ignored if using export
Config.Inv = 'qs' -- can be ox or qs
Config.Target = 'ox_target'

Config.location = {
    {
        UsePed = true, -- Do you want to use a ped?
        coords = vector3(473.815368, -995.498902, 27.830810),
        h = 90,
        size = vec3(3, 2, 3), -- size of the box zone
        rotation = 272, -- Rotation of box zone
        AllowedRank = 3, -- allowed ranks for Chief Options
        cop = true,  -- is this a police job? allows evidence lockers
        job = 'police', -- what job do you want here?
        TargetLabel = 'Öffne Beweismittelschrank', -- easier to label for each job
    }
}

Config.NotificationType = {
    client = 'okokNotify',
    server = 'okokNotify'
}

Config.slots = 50
Config.weight = 500000
