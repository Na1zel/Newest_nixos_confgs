{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    package = null;
    portalPackage = null;
    xwayland.enable = true;
    configType = "lua";
    settings = {};
    extraConfig = ''
      -- monitor
      hl.monitor({ output = "DP-3", mode = "1920x1080@165", position = "0x0", scale = 1 })

      -- config
      local OPACITY = 0.80
      local BORDER = 1
      local ROUNDING = 12
      hl.config({
        general = { layout = "dwindle", gaps_in = 5, gaps_out = 10, border_size = BORDER },
        decoration = {
          rounding = ROUNDING,
          active_opacity = OPACITY,
          inactive_opacity = OPACITY,
          fullscreen_opacity = 1.0,
          shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = 0xee1a1a1a,
          },
          blur = {
            enabled = true,
            size = 6,
            passes = 3,
            noise = 0.0117,
            contrast = 1,
            brightness = 1,
            vibrancy = 0.1696,
            popups = true,
          },
        },
        input = {
          kb_layout = "us,ru",
          kb_options = "grp:alt_shift_toggle",
          accel_profile = "flat",
          sensitivity = 0,
          repeat_delay = 300,
          repeat_rate = 25,
        },
        misc = { vrr = 1 },
      })

      -- dynamic color
      require("noctalia").apply_theme()

      -- noctalia: отключаем анимации Hyprland для её слоёв, блюр за баром и панелями
      hl.layer_rule({
        name = "noctalia",
        match = { namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$" },
        no_anim = true,
        ignore_alpha = 0.5,
        blur = true,
        blur_popups = true,
      })

      -- animations
      hl.curve("mango",      { type = "bezier", points = { {0.46, 1.0}, {0.29, 1} } })
      hl.curve("mangoClose", { type = "bezier", points = { {0.08, 0.92}, {0, 1} } })
      hl.animation({ leaf = "global",     enabled = true, speed = 5,   bezier = "mango" })
      hl.animation({ leaf = "windows",    enabled = true, speed = 5,   bezier = "mango" })
      hl.animation({ leaf = "windowsIn",  enabled = true, speed = 4,   bezier = "mango",      style = "slide" })
      hl.animation({ leaf = "windowsOut", enabled = true, speed = 8,   bezier = "mangoClose", style = "slide" })
      hl.animation({ leaf = "fadeIn",     enabled = true, speed = 4,   bezier = "mango" })
      hl.animation({ leaf = "fadeOut",    enabled = true, speed = 8,   bezier = "mangoClose" })
      hl.animation({ leaf = "workspaces", enabled = true, speed = 3.5, bezier = "mango",      style = "slide" })
      hl.animation({ leaf = "layers",     enabled = true, speed = 4,   bezier = "mango",      style = "slide" })
      hl.animation({ leaf = "border",     enabled = false })

      -- window rules (float-new должно идти первым)
      local float_new = hl.window_rule({ name = "float-new", match = { class = ".*" }, float = true, center = true })
      local float_mode = false -- true = всё плавающее, false = мозаика
      float_new:set_enabled(float_mode)

      hl.window_rule({ name = "suppress-maximize-events", match = { class = ".*" }, suppress_event = "maximize" })
      hl.window_rule({ match = { class = "^(thunar|Thunar)$", title = "Preferences" }, float = true, center = true, size = { 550, 500 } })
      hl.window_rule({ match = { class = "^(thunar|Thunar)$", title = "^(Rename.*)$" }, float = true, move = {"cursor_x-(window_w*0.5)", "cursor_y-(window_h*0.5)"}, size = { 300, 100 } })
      hl.window_rule({ match = { class = "firefox", title = ".*Save.*" }, float = true, center = true })
      hl.window_rule({ match = { class = "firefox", title = ".*Open.*" }, float = true, center = true })
      hl.window_rule({ match = { class = "DesktopEditors" }, float = true, center = true })
      hl.window_rule({ match = { class = "xdg-desktop-portal-gtk", title = ".*Open.*" }, size = {"monitor_w * 0.5", "monitor_h * 0.5"}, float = true, center = true })

      -- apps
      hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("kitty"))
      hl.bind("SUPER + T", hl.dsp.exec_cmd("kitty"))
      hl.bind("SUPER + E", hl.dsp.exec_cmd("pcmanfm"))

      -- windows
      hl.bind("SUPER + Q", hl.dsp.window.close())
      hl.bind("SUPER + W", hl.dsp.window.float({ action = "toggle" }))
      hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
      hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
      hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- плавающий <-> мозаика: и для новых, и для уже открытых окон
      hl.bind("SUPER + SHIFT + W", function()
        float_mode = not float_mode
        float_new:set_enabled(float_mode)

        local action = float_mode and "set" or "unset"
        for _, w in ipairs(hl.get_windows({ mapped = true })) do
          hl.dispatch(hl.dsp.window.float({ action = action, window = w }))
          if float_mode then
            hl.dispatch(hl.dsp.window.center({ window = w }))
          end
        end
      end)

      -- переключение окон
      hl.bind("ALT + TAB", hl.dsp.exec_cmd("noctalia msg window-switcher"))
      hl.bind("SUPER + Tab", function()
        hl.dispatch(hl.dsp.window.cycle_next({}))
        hl.dispatch(hl.dsp.window.bring_to_top())
      end)
      hl.bind("SUPER + SHIFT + Tab", function()
        hl.dispatch(hl.dsp.window.alter_zorder({ mode = "bottom" }))
        hl.dispatch(hl.dsp.window.cycle_next({ next = false }))
      end)

      -- фокус и перемещение (vim + стрелки)
      local dirs = { H = "left", J = "down", K = "up", L = "right", left = "left", right = "right", up = "up", down = "down" }
      for key, dir in pairs(dirs) do
        hl.bind("SUPER + " .. key, hl.dsp.focus({ direction = dir }))
        hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
      end

      -- workspaces
      hl.bind("SUPER + D", hl.dsp.focus({ workspace = "empty" }))
      hl.bind("SUPER + SHIFT + D", hl.dsp.window.move({ workspace = "empty", follow = true }))
      hl.bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "+1" }))
      hl.bind("SUPER + Page_Down", hl.dsp.focus({ workspace = "-1" }))
      hl.bind("SUPER + SHIFT + Page_Up", hl.dsp.window.move({ workspace = "+1" }))
      hl.bind("SUPER + SHIFT + Page_Down", hl.dsp.window.move({ workspace = "-1" }))
      hl.bind("SUPER + C", hl.dsp.workspace.toggle_special("scratchpad"))
      hl.bind("SUPER + SHIFT + C", hl.dsp.window.move({ workspace = "special:scratchpad" }))
      for i = 1, 9 do
        hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = tostring(i) }))
        hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = tostring(i) }))
      end

      -- layouts: SUPER+CTRL+1..4
      local layouts = { "dwindle", "master", "scrolling", "monocle" }
      for i, name in ipairs(layouts) do
        hl.bind("SUPER + CTRL + " .. i, function()
          hl.config({ general = { layout = name } })
        end)
      end

      -- layout-зависимые бинды
      local function layout_bind(bind_table)
        return function()
          local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
          if not workspace then return end
          local layout = workspace.tiled_layout
          if bind_table[layout] then
            hl.dispatch(bind_table[layout])
          end
        end
      end

      hl.bind("SUPER + comma", layout_bind({ master = hl.dsp.layout("mfact -0.01"), scrolling = hl.dsp.layout("colresize -0.01") }), { repeating = true })
      hl.bind("SUPER + period", layout_bind({ master = hl.dsp.layout("mfact +0.01"), scrolling = hl.dsp.layout("colresize +0.01") }), { repeating = true })
      hl.bind("SUPER + SHIFT + comma", layout_bind({ master = hl.dsp.layout("orientationprev"), scrolling = hl.dsp.layout("swapcol l") }))
      hl.bind("SUPER + SHIFT + period", layout_bind({ master = hl.dsp.layout("orientationnext"), scrolling = hl.dsp.layout("swapcol r") }))
      hl.bind("SUPER + slash", layout_bind({ master = hl.dsp.layout("addmaster"), scrolling = hl.dsp.layout("consume") }))
      hl.bind("SUPER + SHIFT + slash", layout_bind({ master = hl.dsp.layout("removemaster"), scrolling = hl.dsp.layout("expel") }))

      -- прозрачность (SUPER+G) и блюр (SUPER+SHIFT+G)
      local opacity_on = true
      hl.bind("SUPER + G", function()
        opacity_on = not opacity_on
        local value = opacity_on and OPACITY or 1.0
        hl.config({ decoration = { active_opacity = value, inactive_opacity = value } })
      end)

      local blur_on = true
      hl.bind("SUPER + SHIFT + G", function()
        blur_on = not blur_on
        hl.config({ decoration = { blur = { enabled = blur_on } } })
      end)

      -- рамки и тень (SUPER+SHIFT+B)
      local fx_on = true
      hl.bind("SUPER + SHIFT + B", function()
        fx_on = not fx_on
        hl.config({
          general = { border_size = fx_on and BORDER or 0 },
          decoration = { shadow = { enabled = fx_on } },
        })
      end)

      -- скругления (SUPER+SHIFT+R): 12 <-> 0, Hyprland + Noctalia (шелл и бар)
      local round_on = true
      
      local function apply_rounding(on)
        local radius = on and ROUNDING or 0
        hl.config({ decoration = { rounding = radius } })
        hl.exec_cmd("noctalia msg config-set shell.corner_radius_scale " .. (on and "1.0" or "0.0"))
        hl.exec_cmd("noctalia msg config-set bar.main.radius " .. radius)
      end
      
      -- синхронизация при старте и при каждой перезагрузке конфига (смена темы)
      apply_rounding(round_on)
      
      hl.bind("SUPER + SHIFT + R", function()
        round_on = not round_on
        apply_rounding(round_on)
      end)

      -- noctalia
      hl.bind("SUPER + A", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
      hl.bind("SUPER + M", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"))
      hl.bind("SUPER + S", hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper"))
      hl.bind("SUPER + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
      hl.bind("SUPER + B", hl.dsp.exec_cmd("noctalia msg bar-toggle"))
      hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("noctalia msg session lock"))
      hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))

      -- звук, яркость, скриншоты, XF86
      hl.bind("SUPER + F9", hl.dsp.exec_cmd("noctalia msg volume-mute"))
      hl.bind("SUPER + F10", hl.dsp.exec_cmd("noctalia msg volume-down 5"), { repeating = true })
      hl.bind("SUPER + F11", hl.dsp.exec_cmd("noctalia msg volume-up 5"), { repeating = true })
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("noctalia msg mic-mute"))
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"))
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up"))
      hl.bind("Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"))
      hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("noctalia msg screenshot-region"))
      hl.bind("XF86Display", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"))
      hl.bind("XF86NotificationCenter", hl.dsp.exec_cmd("noctalia msg power-cycle"))
      hl.bind("XF86PickupPhone", hl.dsp.exec_cmd("noctalia msg bluetooth-toggle"))
      hl.bind("XF86HangupPhone", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))
      hl.bind("XF86Favorites", hl.dsp.exec_cmd("noctalia msg settings-toggle"))
    '';
  };

  # env-переменные для uwsm
  home.sessionVariables = {
    # theme.nix (qt.platformTheme = "qtct") уже ставит qt5ct, поэтому mkForce
    QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
    #QT_STYLE_OVERRIDE = "Darkly";
    XCURSOR_THEME = "Simp1e-Dark";
    XCURSOR_SIZE = "24";
  };

  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  xdg.configFile."uwsm/env-hyprland".text = ''
    export HYPRCURSOR_THEME=Simp1e-Dark
    export HYPRCURSOR_SIZE=24
  '';
}
