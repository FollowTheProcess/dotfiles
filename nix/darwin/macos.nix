{
  flake.modules.darwin.base =
    { config, ... }:
    let
      homeDir = config.users.users.${config.system.primaryUser}.home;
    in
    {
      system.defaults = {
        NSGlobalDomain = {
          AppleInterfaceStyle = "Dark";
          AppleInterfaceStyleSwitchesAutomatically = false;

          AppleMeasurementUnits = "Centimeters";
          AppleMetricUnits = 1;
          AppleTemperatureUnit = "Celsius";
          AppleICUForce24HourTime = true;

          _HIHideMenuBar = false;

          KeyRepeat = 1;
          InitialKeyRepeat = 8;
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
            "${homeDir}/Applications/Home Manager Apps/Ghostty.app"
            "${homeDir}/Applications/Home Manager Apps/Zed.app"
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

      system.startup.chime = false;
    };
}
