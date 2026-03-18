{
  config,
  pkgs,
  username,
  ...
}:
{
  system.defaults = {
    # Global system preferences
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      "com.apple.swipescrolldirection" = false;
      "com.apple.trackpad.forceClick" = true;
    };

    # Dock
    dock = {
      tilesize = 52;
      magnification = true;
      largesize = 94;
      autohide = false;
      show-recents = false;
      wvous-br-corner = 1;
    };

    # Finder
    finder = {
      FXPreferredViewStyle = "clmv";
      NewWindowTarget = "Home";
      FXDefaultSearchScope = "SCcf";
      AppleShowAllExtensions = true;
    };

    # Window Manager
    WindowManager = {
      EnableStandardClickToShowDesktop = false;
      EnableTilingByEdgeDrag = false;
      EnableTilingOptionAccelerator = false;
      EnableTopTilingByEdgeDrag = false;
      HideDesktop = true;
      AppWindowGroupingBehavior = true;
    };

    # Custom user preferences for third-party apps and system hotkeys
    CustomUserPreferences = {
      # Apple Symbolic Hot Keys
      # parameters format: [ASCII code (or 65535=none), virtual keycode, modifier flags]
      # Modifier flags: 262144=Cmd, 524288=Opt, 786432=Cmd+Opt, 1048576=Shift,
      #   1179648=Cmd+Shift, 1441792=Cmd+Opt+Shift, 1572864=Cmd+Shift+Opt,
      #   8650752=Ctrl+Arrow, 8781824=Ctrl+Opt+Arrow
      # Virtual keycodes: 49=Space, 20=3, 21=4, 18=1, 123=Left, 124=Right,
      #   125=Down, 126=Up, 65535=none/unbound
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          # ── Spotlight -> Raycast ──
          # Disable all Spotlight shortcuts so Raycast can use Cmd+Space
          "60" = {
            enabled = false; # Show Spotlight search (Cmd+Space)
            value = {
              parameters = [
                32
                49
                262144
              ];
              type = "standard";
            };
          };
          "61" = {
            enabled = false; # Show Finder search window (Cmd+Opt+Space)
            value = {
              parameters = [
                32
                49
                786432
              ];
              type = "standard";
            };
          };
          "64" = {
            enabled = false; # Show Spotlight search (Shift+Cmd+Space - alternate)
            value = {
              parameters = [
                32
                49
                1048576
              ];
              type = "standard";
            };
          };
          "65" = {
            enabled = false; # Show Finder search window (Cmd+Shift+Opt+Space - alternate)
            value = {
              parameters = [
                32
                49
                1572864
              ];
              type = "standard";
            };
          };

          # ── Screenshots -> CleanShot ──
          # Disable built-in screenshot shortcuts; CleanShot X handles these
          "184" = {
            enabled = false; # Screenshot and recording options (Cmd+Shift+5)
            value = {
              parameters = [
                53
                23
                1179648
              ];
              type = "standard";
            };
          };
          "28" = {
            enabled = false; # Save picture of screen as file (Cmd+Shift+3)
            value = {
              parameters = [
                51
                20
                1179648
              ];
              type = "standard";
            };
          };
          "29" = {
            enabled = false; # Copy picture of screen to clipboard (Cmd+Ctrl+Shift+3)
            value = {
              parameters = [
                51
                20
                1441792
              ];
              type = "standard";
            };
          };
          "30" = {
            enabled = false; # Save picture of selected area as file (Cmd+Shift+4)
            value = {
              parameters = [
                52
                21
                1179648
              ];
              type = "standard";
            };
          };
          "31" = {
            enabled = false; # Copy picture of selected area to clipboard (Cmd+Ctrl+Shift+4)
            value = {
              parameters = [
                52
                21
                1441792
              ];
              type = "standard";
            };
          };

          # ── Window tiling -> Rectangle ──
          # Disable macOS built-in tiling shortcuts (Sequoia+); Rectangle handles window management
          # parameters [65535 65535 0] = unbound (no key, no keycode, no modifiers)
          "215" = {
            enabled = false; # Tile window to left of screen
            value = {
              parameters = [
                65535
                65535
                0
              ];
              type = "standard";
            };
          };
          "216" = {
            enabled = false; # Tile window to right of screen
            value = {
              parameters = [
                65535
                65535
                0
              ];
              type = "standard";
            };
          };
          "217" = {
            enabled = false; # Tile window to top of screen
            value = {
              parameters = [
                65535
                65535
                0
              ];
              type = "standard";
            };
          };
          "218" = {
            enabled = false; # Tile window to bottom of screen
            value = {
              parameters = [
                65535
                65535
                0
              ];
              type = "standard";
            };
          };
          "219" = {
            enabled = false; # Tile window to top-left corner
            value = {
              parameters = [
                65535
                65535
                0
              ];
              type = "standard";
            };
          };
          "225" = {
            enabled = false; # Tile window to top-right corner
            value = {
              parameters = [
                65535
                65535
                0
              ];
              type = "standard";
            };
          };
          "226" = {
            enabled = false; # Tile window to bottom-left corner
            value = {
              parameters = [
                65535
                65535
                0
              ];
              type = "standard";
            };
          };
          "227" = {
            enabled = false; # Tile window to bottom-right corner
            value = {
              parameters = [
                65535
                65535
                0
              ];
              type = "standard";
            };
          };
          "228" = {
            enabled = false; # Fill window (maximize within tile)
            value = {
              parameters = [
                65535
                65535
                0
              ];
              type = "standard";
            };
          };
          "229" = {
            enabled = false; # Center window on screen
            value = {
              parameters = [
                65535
                65535
                0
              ];
              type = "standard";
            };
          };

          # ── Mission Control ──
          # Disable basic Mission Control arrow-key shortcuts (Ctrl+Arrow)
          "32" = {
            enabled = false; # Mission Control (Ctrl+Up)
            value = {
              parameters = [
                65535
                126
                8650752
              ];
              type = "standard";
            };
          };
          "33" = {
            enabled = false; # Application windows (Ctrl+Down)
            value = {
              parameters = [
                65535
                125
                8650752
              ];
              type = "standard";
            };
          };
          "79" = {
            enabled = false; # Move left a space (Ctrl+Left)
            value = {
              parameters = [
                65535
                123
                8650752
              ];
              type = "standard";
            };
          };
          "81" = {
            enabled = false; # Move right a space (Ctrl+Right)
            value = {
              parameters = [
                65535
                124
                8650752
              ];
              type = "standard";
            };
          };

          # Keep Ctrl+Opt+Arrow for switching spaces (less likely to conflict)
          "80" = {
            enabled = true; # Move left a space (Ctrl+Opt+Left)
            value = {
              parameters = [
                65535
                123
                8781824
              ];
              type = "standard";
            };
          };
          "82" = {
            enabled = true; # Move right a space (Ctrl+Opt+Right)
            value = {
              parameters = [
                65535
                124
                8781824
              ];
              type = "standard";
            };
          };

          # ── Notification Center ──
          "164" = {
            enabled = false; # Show Notification Center
            value = {
              parameters = [
                65535
                65535
                0
              ];
              type = "standard";
            };
          };

          # ── Switch to Desktop / Input Sources ──
          "118" = {
            enabled = false; # Switch to Desktop 1 (Ctrl+1)
            value = {
              parameters = [
                65535
                18
                262144
              ];
              type = "standard";
            };
          };
          "15" = {
            enabled = false;
          }; # Select previous input source
          "16" = {
            enabled = false;
          }; # (unused/reserved)
          "17" = {
            enabled = false;
          }; # Select next input source
          "18" = {
            enabled = false;
          }; # (unused/reserved)
          "19" = {
            enabled = false;
          }; # (unused/reserved)
          "20" = {
            enabled = false;
          }; # (unused/reserved)
          "21" = {
            enabled = false;
          }; # Show Desktop (F11)
          "22" = {
            enabled = false;
          }; # (unused/reserved)
          "23" = {
            enabled = false;
          }; # (unused/reserved)
          "24" = {
            enabled = false;
          }; # (unused/reserved)
          "25" = {
            enabled = false;
          }; # (unused/reserved)
          "26" = {
            enabled = false;
          }; # (unused/reserved)
        };
      };

      # Rectangle window manager
      "com.knollsoft.Rectangle" = {
        alternateDefaultShortcuts = true;
        launchOnLogin = true;
        hideMenubarIcon = true;
        subsequentExecutionMode = 1;
        allowAnyShortcut = true;
      };

      # Raycast launcher
      "com.raycast.macos" = {
        raycastGlobalHotkey = "Command-49";
        raycastPreferredWindowMode = "compact";
        raycastShouldFollowSystemAppearance = true;
        "NSStatusItem VisibleCC raycastIcon" = 0;
      };

      # CleanShot X
      "pl.maketheweb.cleanshotx" = {
        captureWithoutDesktopIcons = true;
        deletePopupAfterDragging = true;
        popupAskForDestinationWhenSaving = false;
        popupSize = 2;
        annotateLastSaveURL = "/Users/${username}/Desktop";
      };

      # Itsycal calendar
      "com.mowglii.ItsycalApp" = {
        ClockFormat = "E MMM dd HH:mm:ss ";
        HideIcon = true;
        ShowEventDays = 7;
        ShowWeeks = true;
        WeekStartDOW = 0;
      };

      # Clocker (world clocks in menu bar)
      "com.abhishek.Clocker" = {
        ShowUpcomingEventView = "NO";
        "com.abhishek.menubarCompactMode" = 0;
        defaultTheme = 1;
        displayFutureSlider = 1;
        is24HourFormatSelected = 1;
        startAtLogin = 1;
      };

      # NSGlobalDomain options not exposed as typed nix-darwin options
      NSGlobalDomain = {
        AppleMiniaturizeOnDoubleClick = false;
      };

      # Control Center menu bar visibility
      "com.apple.controlcenter" = {
        "NSStatusItem Visible BentoBox" = 1;
        "NSStatusItem Visible FaceTime" = 0;
        "NSStatusItem VisibleCC Battery" = 1;
        "NSStatusItem VisibleCC Bluetooth" = 1;
        "NSStatusItem VisibleCC Clock" = 1;
        "NSStatusItem VisibleCC Display" = 1;
        "NSStatusItem VisibleCC Sound" = 1;
        "NSStatusItem VisibleCC WiFi" = 1;
      };

      # Menu bar clock (analog, show day of week, no date, no AM/PM)
      "com.apple.menuextra.clock" = {
        IsAnalog = 1;
        ShowAMPM = 0;
        ShowDate = 0;
        ShowDayOfWeek = 1;
      };

      # TimeMachine in menu bar
      "com.apple.systemuiserver" = {
        menuExtras = [
          "/System/Library/CoreServices/Menu Extras/TimeMachine.menu"
        ];
        "NSStatusItem VisibleCC com.apple.menuextra.TimeMachine" = 1;
      };
    };
  };
}
