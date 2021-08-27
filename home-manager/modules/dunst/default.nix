{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.services.dunst;

in {
  options.luksab.services.dunst.enable = mkEnableOption "enable desktop config";
  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          monitor = 0;
          follow = "keyboard";
          geometry = "350x5-0+24";
          indicate_hidden = true;
          shrink = true;
          transparency = 20;
          notification_height = 0;
          separator_height = 2;
          padding = 0;
          horizontal_padding = 8;
          frame_width = 3;
          frame_color = "#282828";
          separator_color = "frame";
          sort = true;
          idle_threshold = 120;
          font = "Monospace 14";
          line_height = 0;
          markup = "full";
          format = "<b>%s</b>\\n%b";
          alignment = "left";
          show_age_threshold = 60;
          word_wrap = true;
          ellipsize = "middle";
          ignore_newline = false;
          stack_duplicates = true;
          hide_duplicate_count = true;
          show_indicators = true;
          icon_position = "left";
          max_icon_size = 40;
          #icon_path = /usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/:/usr/share/icons/Adwaita/256x256/status/;
          sticky_history = true;
          history_length = 20;

          # Always run rule-defined scripts, even if the notification is suppressed;
          always_run_script = true;

          title = "Dunst";
          class = "Dunst";
          startup_notification = false;
          force_xinerama = false;
        };
        urgency_low = {
          background = "#282828";
          foreground = "#928374";
          timeout = 5;
        };
        urgency_normal = {
          background = "#458588";
          foreground = "#ebdbb2";
          timeout = 5;
        };
        urgency_critical = {
          background = "#cc2421";
          foreground = "#ebdbb2";
          frame_color = "#fabd2f";
          timeout = 0;
        };
      };
    };
  };
}
