ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj 
end)

local open = false
local lancer = false
local MenuGoFast = RageUI.CreateMenu("GoFast", "Interaction")
local sub_menugo = RageUI.CreateSubMenu(MenuGoFast, "", "INTERACTION")

MenuGoFast.Display.Header = true 
MenuGoFast.Close = function()
    open = false 
end 

function OpenMenuGoFast()
    if open then 
        open = false 
        RageUI.Visible(MenuGoFast, true)
        return 
    else 
        open = true 
        RageUI.Visible(MenuGoFast, true)
        CreateThread(function()
            while open do 
                RageUI.IsVisible(MenuGoFast, function()
                    RageUI.Button("~c~→~s~ Voir les GoFast Disponible", "Appuyer sur entrer pour voir les ~g~différent véhicule !", {RightLabel = ""}, true, {}, sub_menugo)
                end)
                 
                RageUI.IsVisible(sub_menugo, function()
                    RageUI.Button("~c~→~s~ Commencer le GoFast" , nil, { RightLabel = "" , Color = { BackgroundColor = { 0, 200, 0, 160 } } }, true, {
                        onActive = function() -- activer la camera
                            UpdateCam("Tyrus", vector3(327.96, 2628.69, 44.32), 24.46)
                            pointerlacam()
                        end,
                        onSelected = function() -- si le joueur s�lectionne ce bouton
                            spawnCar('tyrus')
                            gofastvente()
                            ESX.ShowAdvancedNotification("Patron", "~r~Message", "~r~attention~s~ ~b~la police~s~ a été prévenue de ton ~r~départ !", "CHAR_MP_FAM_BOSS", 7)
                            retourcam() -- retourner sur la cam�ra du joueur
                            stopprevue() -- arr�ter l'hologramme du v�hicule
                            RageUI.CloseAll() -- fermer le menu en entier
                            open = false
                        end
                    })
                end)
            Wait(0)
            end
        end)
    end   
end

Citizen.CreateThread(function()
    while true do
		local wait = 750

			for k in pairs(Config.gofastpos) do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local pos = Config.gofastpos
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

            if dist <= Config.MarkerDistance then
                wait = 0
                Visual.Subtitle("Appuyer sur [~b~E~s~] pour ouvrir le menu ~r~GoFast !")
                DrawMarker(Config.MarkerType, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.MarkerSizeLargeur, Config.MarkerSizeEpaisseur, Config.MarkerSizeHauteur, Config.MarkerColorR, Config.MarkerColorG, Config.MarkerColorB, Config.MarkerOpacite, Config.MarkerSaute, true, p19, Config.MarkerTourne)  
            end

			if dist <= 0.9 then
                wait = 0
                if IsControlJustPressed(1,51) then
                    OpenMenuGoFast()
                end
		    end
		end
    Wait(wait)
    end
end)

spawnCar = function(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Wait(0)
    end

    local vehicle = CreateVehicle(car, 327.96, 2628.68, 44.12, 24.50, true, false)
	SetVehicleNumberPlateText(vehicle, "GOFAST")
	SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0)
	SetVehicleCustomSecondaryColour(vehicle, 0, 0, 0)
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    TriggerServerEvent("vgofast:lspd")
end

function gofastvente()
	SetNewWaypoint(-2544.15, 2316.38, 33.60)
end


local positionPedGoFast = {
	{x = 317.16, y = 2623.00, z = 43.45, h = 310.26} 
}


-- Blip 
Citizen.CreateThread(function()
    for i=1, #Config.gofastpos, 1 do 
        local gofastblip = AddBlipForCoord(Config.gofastpos[i].x, Config.gofastpos[i].y, Config.gofastpos[i].z)
        SetBlipSprite(gofastblip, 632)
        SetBlipColour(gofastblip, 47)
        SetBlipScale(gofastblip, 0.9)
        SetBlipAsShortRange(gofastblip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("~r~GoFast")
        EndTextCommandSetBlipName(gofastblip)
    end
end)


Citizen.CreateThread(function()
    local hash = GetHashKey("u_m_m_aldinapoli")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
	end
	for k,v in pairs(positionPedGoFast) do
	ped = CreatePed("PED_TYPE_CIVMALE", "u_m_m_aldinapoli", v.x, v.y, v.z, v.h, false, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
	end
end)

tempVeh = nil
local tempModel = nil

function stopprevue() -- function qui permet d'arrêter l'hologramme du véhicule
    TriggerEvent("InitCamModulePause", false)
    DeleteEntity(tempVeh)
    tempVeh = nil
    tempModel = nil
end

function UpdateCam(model, coords, heading)
    if model == tempModel then
        return
    else
        if tempVeh ~= nil then
            DeleteEntity(tempVeh)
            tempVeh = nil
        end

        RequestModel(GetHashKey(model))
        while not HasModelLoaded(GetHashKey(model)) do Wait(1) end
        
        tempModel = model
        tempVeh = CreateVehicle(GetHashKey(model), coords, heading, 0, 0)
        FreezeEntityPosition(tempVeh, true)
        SetEntityAlpha(tempVeh, 180, 180)

local vente = false 
local mainMenu2 = RageUI.CreateMenu('Vente', 'interaction')
mainMenu2.Closed = function()
	vente = false
end

function gofastventemenu()
    if vente then 
        vente = false
        RageUI.Visible(mainMenu2, false)
        return
    else
        vente = true 
        RageUI.Visible(mainMenu2, true)
        CreateThread(function()
        	while vente do 
           		RageUI.IsVisible(mainMenu2,function() 
            		RageUI.Button("~c~→~s~ Donner le véhicule", nil, {RightLabel = ""}, true , {
               			onSelected = function()	
							FinDeGoFast()
                			RageUI.CloseAll()
							vente = false
               			end
            		})  
           		end)
         	Wait(0)
        	end
    	end)
  	end
end

local vente = {{x = -2544.15, y = 2316.38, z = 33.60}}

Citizen.CreateThread(function()
    while true do
      local wait = 900
        for k in pairs(vente) do	
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, vente[k].x, vente[k].y, vente[k].z)        
            if dist <= 2.0 then
               wait = 0			   
                Visual.Subtitle("Appuyez sur [~r~E~w~] pour Vendre le ~r~véhicule", 1) 
                if IsControlJustPressed(1,51) then
					gofastventemenu()
           		end
        	end
        end
    Citizen.Wait(wait)
	end
end)

function FinDeGoFast()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn( ped, false )
	local plate = GetVehicleNumberPlateText(vehicle)
	if plate == ' GOFAST ' then
		
		ESX.Game.DeleteVehicle(vehicle)
		ESX.ShowAdvancedNotification("GoFast", "~r~Anonyme", "J'ai bien recu le véhicule de ta pars !", "CHAR_MALC", 7)
		TriggerServerEvent("vgofast:venteduvehicle")
        local playerPos = GetEntityCoords(PlayerPedId())
        local hash = GetHashKey(Config.VehicleFin)
        RequestModel(hash)
        while not HasModelLoaded(hash) do Wait(10) end 

        local veh = CreateVehicle(hash,  playerPos.x, playerPos.y, playerPos.z, 90.00, true, false)
        SetVehicleNumberPlateText(veh, "LOCATION")
		Wait(10)
		local playerPed = PlayerPedId()
    else
        ESX.ShowAdvancedNotification("GoFast", "~r~Anonyme", "Tu te fous de moi ?! Donne moi ce ~r~véhicule !", "CHAR_MALC", 7)
        
	end
end

        local camCoords = GetOffsetFromEntityInWorldCoords(tempVeh, 3.0, 2.0, 2.0)
    end
end

function pointerlacam() -- function pour pointer la caméra sur le véhicule
    cam = CreateCam("DEFAULT_SCRIPTED_Camera", 1)
    SetCamCoord(cam, 326.34, 2635.31, 44.56, 13.68, true, 0)
    RenderScriptCams(500, 100, 1000, 1000, 100)
    PointCamAtCoord(cam, 343.1698913, 343.1698913, 343.1698913)
    DisplayRadar(false)
end

function retourcam() -- function pour faire revenir la caméra sur le joueur
    RenderScriptCams(false, true, 500, true, true)
    SetCamActive(cam, false)
    DestroyAllCams(true)
    DisplayRadar(false) -- mettre true si votre radar est activé par défaut sur votre serveur
end

sub_menugo.Closed = function() retourcam() end -- lorsque le menu voiture est fermé, revenir a la caméra du joueur