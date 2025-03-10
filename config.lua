Config = {}

Config.CowLocations = {
    vector3(2200.0, 4900.0, 40.0),
    vector3(2205.0, 4905.0, 40.0),
    vector3(2210.0, 4910.0, 40.0),
    vector3(2215.0, 4915.0, 40.0),
    vector3(2220.0, 4920.0, 40.0)
}

Config.MilkProcessing = vector3(2150.0, 4800.0, 40.0)

Config.MilkSelling = vector3(2550.0, 4650.0, 33.0)

Config.MilkPrice = 10

Config.Blips = {
    {coords = Config.CowLocations[1], sprite = 141, color = 17, scale = 0.8, label = "Ferme (Traite)"},
    {coords = Config.MilkProcessing, sprite = 436, color = 28, scale = 0.8, label = "Usine Laitière"},
    {coords = Config.MilkSelling, sprite = 500, color = 46, scale = 0.8, label = "Marché Laitier"}
}
