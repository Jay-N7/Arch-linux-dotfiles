-- https://wiki.hypr.land/Configuring/Start/

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")

------------------
---- MONITORS ----
------------------
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto", })
hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 1, })
hl.monitor({ output = "DP-1", mode = "preferred", position = "1366x0", scale = 1, })

-- hl.monitor({ output = "name", disabled = true })
-- This is a key-binf written at the bottom for toggling the laptop screen 
-- hl.bind(mainMod .. " + F10", function()
--     state = not state
--     hl.monitor({ output = "eDP-1", disabled = state })
-- end)
-- mirroring display : 
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1, mirror = "DP-1" })
---------------------
---- MY PROGRAMS ----
---------------------
-- Set programs that you use
local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "wofi"

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
    -- Authentication / keyring
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg")
    -- Background daemons
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("clipman store")
    hl.exec_cmd("swaync")
    hl.exec_cmd("hypridle")
    -- Status bar
    hl.exec_cmd("waybar")
    -- Scripts
    hl.exec_cmd("~/scripts/battery-watch.sh")
    -- Power tuning
    -- Requires sudoers NOPASSWD rule
    -- hl.exec_cmd("sudo /usr/sbin/powertop --auto-tune")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 6,
        gaps_out = 12,
        border_size = 0,
        col = {
            active_border   = { colors = {"rgba(eb6f92ff)"}},
            -- active_border   = { colors = {"rgba(e3ecf3ff)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(000000ff)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,
        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        -- rounding       = 6,
        -- rounding_power = 3,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 0.8,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = false,
            size      = 6,
            passes    = 2,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

hl.layer_rule({
    match = { namespace = "wofi" },
    blur = true,
    ignore_alpha = 0.2,
})
-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        -- disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
        disable_hyprland_logo   = 1, -- If true disables the random hyprland logo / anime girl background. :(
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "ctrl:swapcaps, altwin:swap_alt_win",
        kb_rules   = "",
        follow_mouse = 1,
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
        touchpad = {
            natural_scroll = true,
        },
    },
})

function resize_toggling()
    hl.dispatch( hl.dsp.window.float({ action = "toggle" }))
    hl.dispatch( hl.dsp.window.resize({ x = 1000, y = 600 })
    )
end
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "down", action =  function()
    hl.dispatch(hl.dsp.workspace.toggle_special("control"))
end})

hl.gesture({ fingers = 3, direction = "up", scale = 1.5, action = resize_toggling })
hl.gesture({ fingers = 3, direction = "down", scale = 1.5, action = "fullscreen" })

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
-- hl.device({
--     name        = "epic-mouse-v1",
--     sensitivity = -0.5,
-- })


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
-- hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("wlogout"))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("wofi --show drun --style ~/.config/wofi/style.css"))

hl.bind(mainMod .. " + V", function()
    hl.dispatch( hl.dsp.window.float({ action = "toggle" }))
    hl.dispatch( hl.dsp.window.resize({ x = 900, y = 600 }))
end)

hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only

-- Custom
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("sh -c 'cliphist list | wofi --show dmenu | cliphist decode | wl-copy'"))

-- scripts (convert ltere to lua functions)
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("~/scripts/change_wallpaper.sh"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("~/scripts/toggle-waybar.sh"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("~/scripts/change_waybar.sh"))

local state = false
hl.bind(mainMod .. " + F10", function()
    state = not state
    hl.monitor({ output = "eDP-1", disabled = state })
end)

    -- Webapps chromium [NORMAL]
    local chrome_app = function(url)
        return hl.dsp.exec_cmd("chromium --app=" .. url)
    end
        hl.bind(mainMod .. " + ALT + Y", chrome_app("https://youtube.com"))
        hl.bind(mainMod .. " + ALT + S", chrome_app("https://spotify.com"))
        hl.bind(mainMod .. " + ALT + G", chrome_app("https://github.com/"))
        hl.bind(mainMod .. " + ALT + M", chrome_app("https://gmail.com"))
        hl.bind(mainMod .. " + ALT + T", chrome_app("https://teams.cloud.microsoft"))
        hl.bind(mainMod .. " + ALT + D", chrome_app("https://discord.com/channels/@me/1342902241459437692"))
          
    -- Webapps chromium [INCOGNITO]
    local incognito_app = function(url)
        return hl.dsp.exec_cmd("chromium --incognito --app=" .. url)
    end
        hl.bind(mainMod .. " + ALT + C", incognito_app("https://chatgpt.com"))
        hl.bind(mainMod .. " + ALT + A", incognito_app("https://allmanga.to"))
        hl.bind(mainMod .. " + ALT + H", incognito_app("https://wiki.hypr.land/Configuring"))
    
    -- Normal apps 
        hl.bind(mainMod .. " + ALT + O", hl.dsp.exec_cmd("obsidian"))
        hl.bind(mainMod .. " + ALT + Q", hl.dsp.exec_cmd("qutebrowser"))
        hl.bind(mainMod .. " + ALT + F", hl.dsp.exec_cmd("firefox"))
        hl.bind(mainMod .. " + ALT + N", hl.dsp.exec_cmd("nextcloud"))



-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + X",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + T",         hl.dsp.workspace.toggle_special("control"))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.window.move({ workspace = "special:control" }))


-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- adding custom movements 
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "e+1" }))

hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ workspace = "e+1" }))

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

-- Custom windows rules 
hl.window_rule({ match = { class = "thunar" }, float = true })
hl.window_rule({ match = { class = "blueman-manager" }, float = true })
hl.window_rule({ match = { class = "calculator" }, float = true })
-- Direct a specific class (e.g., Spotify) to a named special workspace
hl.window_rule({
    name = "spotify-scratchpad",
    match = { class = "chrome-spotify.com__-Default" },
    workspace = "special:control",
    float = true,
    size = { "monitor_w * 0.7", "monitor_h * 0.7" },
    move = { "monitor_w * 0.02", "monitor_h * 0.05" }
})



-- local INTERNAL = "eDP-1"
-- local function external_count()
--     local n = 0
--     for _, m in ipairs(hl.get_monitors() or {}) do
--         if not (m.name and m.name:sub(1,3) == "eDP") then n = n + 1 end
--     end
--     return n
-- end
--
-- local function apply()
--     if external_count() >= 1 then
--         hl.monitor({ output = INTERNAL, disabled = true })
--     else
--         hl.monitor({ output = INTERNAL, disabled = false })
--         -- hl.monitor({ output = INTERNAL, mode = "1366x768@60Hz", position = "0x0", scale = 1 })
--     end
-- end
-- hl.on("monitor.added",   apply)
-- hl.on("monitor.removed", apply)
-- hl.on("config.reloaded", apply) 
