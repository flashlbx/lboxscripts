local STEP = -1
local STEPS = {
    [0] = function(cmd)
        cmd:SetButtons(cmd.buttons | IN_RELOAD)
        --cmd:SetButtons(cmd.buttons | IN_ATTACK2)
        STEP = STEP + 1
    end,
    [6] = function(cmd)
        cmd:SetButtons(cmd.buttons | IN_ATTACK2)
        STEP = STEP + 1
    end,
    [13] = function(cmd)
        cmd:SetButtons(cmd.buttons | IN_ATTACK2)
        STEP = STEP + 1
    end,
    [55] = function(cmd)
        STEP = -1
        gui.SetValue("aim bot", 1)
    end
}

local function CreateMove(cmd)
    local player = entities.GetLocalPlayer()
    if (player == nil) or (player:GetPropInt("m_iClass") ~= 8) or ((player:GetPropInt("m_Shared", "m_bFeignDeathReady") == 1) and STEP == -1) then return end
    if player:IsAlive() then
        local prim = player:GetEntityForLoadoutSlot(1)
        if not (STEP > -1) and (cmd.buttons & IN_RELOAD) ~= 0 and prim:GetPropInt("m_iClip1") ~= 6 then
            STEP = 0
        end
        if STEP > -1 then
            gui.SetValue("aim bot", 0)
            cmd:SetButtons(cmd.buttons & ~IN_ATTACK)
            if STEPS[STEP] == nil then
                STEP = STEP + 1
            else
                STEPS[STEP](cmd)
            end
        end
    end
end
callbacks.Unregister("CreateMove", "rv_createmove")
callbacks.Register("CreateMove", "rv_createmove", CreateMove)