local show3DText = true
-- ID Over Head Part
local disPlayerNames = 5
local playerDistances = {}
-- ID Over Head Part ^

RegisterNetEvent("combat:showDisconnect")
AddEventHandler("combat:showDisconnect", function(id, crds, reason)
    Display(id, crds, reason)
end)

function Display(id, crds, reason)
    local displaying = true

    Citizen.CreateThread(function()
        Wait(Config.DrawingTime)
        displaying = false
    end)
	
    Citizen.CreateThread(function()
        while displaying do
            Wait(5)
            local pcoords = GetEntityCoords(PlayerPedId())
            if GetDistanceBetweenCoords(crds.x, crds.y, crds.z, pcoords.x, pcoords.y, pcoords.z, true) < 15.0 and show3DText then
                DrawText3DSecond(crds.x, crds.y, crds.z+0.15, "Player Left Game")
                DrawText3D(crds.x, crds.y, crds.z, "ID: "..id.."\nReason: "..reason)
            else
                Citizen.Wait(2000)
            end
        end
    end)
end

function DrawText3DSecond(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.45, 0.45)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(Config.AlertTextColor.r, Config.AlertTextColor.g, Config.AlertTextColor.b, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.45, 0.45)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(Config.TextColor.r, Config.TextColor.g, Config.TextColor.b, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

local function DrawText3D(position, text, r,g,b) 
    local onScreen,_x,_y=World3dToScreen2d(position.x,position.y,position.z+1)
    local dist = #(GetGameplayCamCoords()-position)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        if not useCustomScale then
            SetTextScale(0.0*scale, 0.55*scale)
        else 
            SetTextScale(0.0*scale, customScale)
        end
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

Citizen.CreateThread(function()
	Wait(500)
    while true do
		tmp = playerDistances
        for v, k in ipairs(tmp) do
			id = k.id
            local targetPed = GetPlayerPed(id)
            local targetPedCords = GetEntityCoords(targetPed)
			if NetworkIsPlayerTalking(id) then
				DrawText3D(targetPedCords, GetPlayerServerId(id), 247,124,24)
				--DrawMarker(27, targetPedCords.x, targetPedCords.y, targetPedCords.z-0.97, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 173, 216, 230, 100, 0, 0, 0, 0)
			else
				--DrawText3D(targetPedCords, GetPlayerServerId(id), 255,255,255)
			end
        end
        Citizen.Wait(5)
    end
end)

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        playerDistances = {}
		
        for _, id in ipairs(GetActivePlayers()) do
            local targetPed = GetPlayerPed(id)
            if targetPed ~= nil and targetPed ~= playerPed then
                local distance = #(playerCoords-GetEntityCoords(targetPed))
				if distance < disPlayerNames then
					playerDistances[id] = id
					table.insert(playerDistances, {
						id = id
					})
				end
            end
        end
        Wait(2000)
    end
end)