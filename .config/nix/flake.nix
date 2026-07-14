{
  description = "My macOS system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.vim
        ];


      # Auto upgrade nix package
      # Maybe uncomment this later
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Use fingerprint rather than password for sudo
      security.pam.services.sudo_local.touchIdAuth = true;

      system.primaryUser = "tomfleet";

      networking.computerName = "onyx";
      networking.hostName = "onyx";
      networking.localHostName = "onyx";

      system.defaults = {
        NSGlobalDomain = {
          AppleInterfaceStyle = "Dark";
          AppleInterfaceStyleSwitchesAutomatically = false;

          AppleMeasurementUnits = "Centimeters";
          AppleMetricUnits = 1;
          AppleTemperatureUnit = "Celsius";
          AppleICUForce24HourTime = true;

          _HIHideMenuBar = true;

          KeyRepeat = 1;
          InitialKeyRepeat = 10;
          ApplePressAndHoldEnabled = false;
          AppleKeyboardUIMode = 3;

          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
          PMPrintingExpandedStateForPrint = true;
          PMPrintingExpandedStateForPrint2 = true;

          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;

          "com.apple.trackpad.scaling" = 3.0;
          NSWindowShouldDragOnGesture = true;

          AppleShowAllExtensions = true;
          NSTableViewDefaultSizeMode = 2;
        };

        controlcenter = {
          Bluetooth = true;
          BatteryShowPercentage = true;
        };

        dock = {
          persistent-apps = [
            "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
            "/Applications/Slack.app"
            "/Applications/WhatsApp.app"
            "/System/Applications/Messages.app"
            "/Applications/Spotify.app"
            "/System/Applications/Mail.app"
            "/System/Applications/Calendar.app"
            "/System/Applications/Notes.app"
            "/System/Applications/Reminders.app"
            "/Applications/1Password.app"
            "/Applications/Obsidian.app"
            "/Applications/Things3.app"
            "/Applications/Ghostty.app"
            "/Applications/Zed.app"
            "/System/Applications/System Settings.app"
          ];

          minimize-to-application = true;
          autohide = true;
          show-recents = false;
          expose-group-apps = true;
          mru-spaces = false;

          tilesize = 26;
          magnification = true;
          largesize = 40;
          orientation = "right";

          wvous-tl-corner = 1;
          wvous-tr-corner = 1;
          wvous-bl-corner = 1;
          wvous-br-corner = 4;
        };

        spaces.spans-displays = false;

        WindowManager.GloballyEnabled = false;

        finder = {
          NewWindowTarget = "Documents";
          FXPreferredViewStyle = "clmv";
          _FXSortFoldersFirst = true;
          FXRemoveOldTrashItems = true;
          QuitMenuItem = true;
          AppleShowAllFiles = true;
          ShowPathbar = true;
          ShowStatusBar = true;
          _FXShowPosixPathInTitle = true;
          FXDefaultSearchScope = "SCcf";
          FXEnableExtensionChangeWarning = false;
        };

        LaunchServices.LSQuarantine = false;

        screencapture = {
          target = "clipboard";
          type = "png";
        };

        ActivityMonitor = {
          ShowCategory = 100;
          SortColumn = "CPUUsage";
          SortDirection = 0;
        };

        CustomUserPreferences = {
          NSGlobalDomain.AppleLocale = "en_GB";

          "com.apple.finder" = {
            FXEnableRemoveFromICloudDriveWarning = false;
            WarnOnEmptyTrash = false;
          };

          "com.apple.desktopservices" = {
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };

          "com.apple.ImageCapture".disableHotPlug = true;

          "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;

          "com.apple.TextEdit" = {
            RichText = 0;
            PlainTextEncoding = 4;
            PlainTextEncodingForWrite = 4;
          };

          "com.apple.mail".DisableInlineAttachmentViewing = true;

          "com.apple.AppStore".AutoPlayVideoSetting = "off";

          "com.apple.Safari" = {
            AutoOpenSafeDownloads = false;
            ShowOverlayStatusBar = true;
            IncludeDevelopMenu = true;
            WebKitDeveloperExtrasEnabledPreferenceKey = true;
            "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
            WebAutomaticSpellingCorrectionEnabled = false;
            AutoFillFromAddressBook = false;
            AutoFillPasswords = false;
            AutoFillCreditCardData = false;
            AutoFillMiscellaneousForms = false;
          };
        };

        CustomSystemPreferences = {
          "com.apple.SoftwareUpdate".AutomaticCheckEnabled = true;
        };
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."onyx" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
