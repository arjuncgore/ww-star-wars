local waywall = require("waywall")
local helpers = require("waywall.helpers")

local example_cfg = {
    startstop = "F8",
    x = 10,
    y = 1000,
    height = 2000,
    size = 1,
    color = "#FFE81F",
    delay = 10,
    text = [[
    It is a period of civil war.
    Rebel spaceships, striking
    from a hidden base, have
    won their first victory
    against the evil Galactic
    Empire.

    During the battle, rebel
    spies managed to steal
    secret plans to the Empire's
    ultimate weapon, the
    DEATH STAR, an armored space
    station with enough
    power to destroy an entire
    planet.

    Pursued by the Empire's
    sinister agents, Princess
    Leia races home aboard her
    starship, custodian of the
    stolen plans that can save
    her people and restore
    freedom to the galaxy....
        ]]
}


local M = {}

local run_id = 0
local text_obj = nil

local handle_scroll = function(cfg)
    if text_obj then
        run_id = run_id + 1
        if text_obj then
            text_obj:close(); text_obj = nil
        end
        return
    end

    run_id = run_id + 1
    local cur_id = run_id

    local _, line_count = string.gsub(cfg.text, "\n", "")
    local text_height = cfg.size * 10 * (line_count + 1)
    local final_y = cfg.y - cfg.height - text_height

    for cur_y = cfg.y, final_y, -1 do
        if cur_id ~= run_id then return end
        if text_obj then
            text_obj:close(); text_obj = nil
        end

        print(cur_y)

        text_obj = waywall.text(cfg.text, {
            x = cfg.x,
            y = cur_y,
            size = cfg.size,
            color = cfg.color,
        })
        waywall.sleep(cfg.delay)
    end

    if cur_id == run_id then
        if text_obj then
            text_obj:close(); text_obj = nil
        end
    end
end


M.setup = function(config, cfg)
    cfg = cfg or example_cfg

    config.actions[cfg.startstop] = function()
        handle_scroll(cfg)
    end
end

return M
