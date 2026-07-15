{
  description = "My macOS system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    paneru.url = "github:karinushka/paneru";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      home-manager,
      paneru,
    }:
    let
      configuration = { pkgs, ... }: {
        # Not everything has a free license
        nixpkgs.config.allowUnfree = true;

        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = [
          pkgs.vim
          pkgs.git
          pkgs.curl
        ];

        fonts.packages = [
          pkgs.geist-font # Geist + Geist Mono
          pkgs.nerd-fonts.geist-mono # Nerd-patched Geist Mono for the terminal
          pkgs.inter
          pkgs.sketchybar-app-font
        ];

        homebrew = {
          enable = true;

          onActivation = {
            autoUpdate = true;
            upgrade = true;
            cleanup = "zap"; # remove anything not listed here
          };

          taps =
            map
              (name: {
                inherit name;
                trusted = true;
              })
              [
                "charmbracelet/tap"
                "followtheprocess/tap"
                "nao1215/tap"
                "olets/tap"
                "taiki-e/tap"
                "theboredteam/boring-notch"
              ];

          # TODO: Most/all of these should be in home-manager but this keeps
          # the build working for now while I'm halfway
          brews = [
            "zsh-autosuggestions"
            "zsh-completions"
            "zsh-fast-syntax-highlighting"
            "charmbracelet/tap/freeze"
            "nao1215/tap/gup"
            "olets/tap/zsh-abbr"
          ];

          # GUI apps don't always play nicely with nix
          casks = [
            "1password-cli"
            "theboredteam/boring-notch/boring-notch"
            "brainfm"
            "claude-code@latest"
            "docker-desktop"
            "ghostty"
            "followtheprocess/tap/git-rekt"
            "followtheprocess/tap/gowc"
            "obsidian"
            "raycast"
            "slack"
            "followtheprocess/tap/spok"
            "spotify"
            "followtheprocess/tap/tag"
            "followtheprocess/tap/txtract"
            "yaak"
            "zed"
          ];

          # masApps omitted: `mas` cannot install under sudo (no App Store session).
          # These apps are pre-installed manually and left unmanaged by nix.
          masApps = {};
        };

        launchd.user.envVariables =
          let
            home = "/Users/tomfleet";
          in
          {
            PATH = pkgs.lib.concatStringsSep ":" [
              "/run/current-system/sw/bin" # nix-darwin systemPackages
              "/etc/profiles/per-user/tomfleet/bin" # home-manager user packages
              "${home}/.nix-profile/bin" # nix user profile
              "/nix/var/nix/profiles/default/bin" # nix itself
              "${home}/go/bin"
              "${home}/.bun/bin"
              "${home}/.local/bin"
              "${home}/.cargo/bin"
              "/opt/homebrew/bin" # Homebrew, after nix so nix wins
              "/opt/homebrew/sbin"
              "/opt/homebrew/opt/curl/bin"
              "/opt/homebrew/opt/ruby/bin"
              "/usr/local/bin"
              "/usr/bin"
              "/bin"
              "/usr/sbin"
              "/sbin"
            ];

            XDG_CONFIG_HOME = "${home}/.config";
            XDG_CACHE_HOME = "${home}/.cache";
            XDG_DATA_HOME = "${home}/.local/share";
            XDG_STATE_HOME = "${home}/.local/state";
          };

        # Auto upgrade nix package
        # Maybe uncomment this later
        # nix.package = pkgs.nix;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Enable alternative shell support in nix-darwin.
        programs.zsh.enable = true;

        # Disable nix-darwin's compinit in /etc/zshrc. My user .zshrc handles it
        # with -i (ignore insecure) and a 24-hour cache, avoiding annoying interactive questions
        programs.zsh.enableCompletion = false;

        # Add nix profile paths to /etc/zshrc so they're available in ALL interactive shells
        programs.zsh.interactiveShellInit = ''
          typeset -U path PATH
          path=(
            /run/current-system/sw/bin
            /etc/profiles/per-user/$USER/bin
            $HOME/.nix-profile/bin
            /nix/var/nix/profiles/default/bin
            $path
          )
        '';

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

        # nix-darwin leaves users.users.<name>.home = null by default, but
        # home-manager now derives home.homeDirectory from it, so declare it.
        users.users.tomfleet = {
          name = "tomfleet";
          home = "/Users/tomfleet";
        };

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

            _HIHideMenuBar = false;

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
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = "tomfleet";
              autoMigrate = true;
              # I'd have to specify every tap as an input, maybe one day
              # but for now I'm leaving this off
              # mutableTaps = false;
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.tomfleet = import ./home.nix;
            home-manager.sharedModules = [ paneru.homeModules.paneru ];
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."onyx".pkgs;
    };
}
