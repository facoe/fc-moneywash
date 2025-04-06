Config = {}

-- Tasa de conversión por tipo de dinero ilegal
-- Formato: [nombre_del_item] = tasa (0.8 = 80%)
Config.MoneyWashRates = {
    black_money = 0.8,
    counterfeit_money = 0.5
}

-- Ubicaciones configurables para lavar dinero
Config.PedLocations = {
    vector4(-595.28, -710.81, 112.51, 239.85), -- Agencia
    vector4(993.79, 68.53, 77.98, 237.99), -- Casino
    vector4(-2985.77, 58.16, 7.48, 150.00), -- Pacific
    vector4(-1539.51, 81.89, 56.26, 107.00), -- Playboy
    vector4(-1571.44, -589.16, 108.0, 36.00), -- Lombank
}

-- Modelo del NPC
Config.PedModel = "a_f_y_business_01"
