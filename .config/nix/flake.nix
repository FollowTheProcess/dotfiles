{
  description = "My macOS system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, ... }: {
      # Not everything has a free license
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.vim
          pkgs.git
          pkgs.curl
        ];

      fonts.packages = [
        pkgs.geist-font            # Geist + Geist Mono
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

        taps = map (name: { inherit name; trusted = true; }) [
          "charmbracelet/tap"
          "common-fate/granted"
          "felixkratz/formulae"
          "fluxcd/tap"
          "followtheprocess/tap"
          "go-task/tap"
          "goreleaser/tap"
          "hashicorp/tap"
          "kluctl/tap"
          "nao1215/tap"
          "nikitabobko/tap"
          "olets/tap"
          "taiki-e/tap"
          "theboredteam/boring-notch"
        ];

        # TODO: Most/all of these should be in home-manager but this keeps
        # the build working for now while I'm halfway
        brews = [
          "openssl@3"
          "readline"
          "sqlite"
          "xz"
          "node"
          "action-docs"
          "shellcheck"
          "actionlint"
          "atuin"
          "awscli"
          "bash"
          "bat"
          "btop"
          "carapace"
          "cargo-nextest"
          "gcc"
          "openblas"
          "checkov"
          "cmake"
          "container"
          "cookcli"
          "cosign"
          "cue"
          "curl"
          "dagger"
          "defuddle"
          "delve"
          "difftastic"
          "direnv"
          "docker-language-server"
          "doggo"
          "dust"
          "entr"
          "erdtree"
          "eza"
          "fastfetch"
          "fd"
          "findutils"
          "usage"
          "fnox"
          "fzf"
          "fzf-tab"
          "gdbm"
          "gh"
          "git"
          "glow"
          "gnu-sed"
          "gnu-tar"
          "gnupg"
          "go"
          "gofumpt"
          "golangci-lint"
          "golangci-lint-langserver"
          "gomodifytags"
          "graphviz"
          "gum"
          "hadolint"
          "helm"
          "hugo"
          "hurl"
          "hyperfine"
          "jj"
          "jq"
          "just"
          "k6"
          "k9s"
          "ko"
          "kubectx"
          "kubernetes-cli"
          "kustomize"
          "lua"
          "luarocks"
          "make"
          "marp-cli"
          "mas"
          "mdbook"
          "mergiraf"
          "minikube"
          "mise"
          "nushell"
          "pandoc"
          "paneru"
          "pinentry-mac"
          "pkgsite"
          "procs"
          "redocly-cli"
          "ripgrep"
          "ruby"
          "ruff"
          "rumdl"
          "shfmt"
          "solargraph"
          "starship"
          "staticcheck"
          "stern"
          "stow"
          "syft"
          "television"
          "terraform-docs"
          "terraform-ls"
          "tflint"
          "tlrc"
          "tokei"
          "tombi"
          "tree"
          "tree-sitter-cli"
          "trivy"
          "typos-cli"
          "uv"
          "vhs"
          "watchexec"
          "wget"
          "yamlfmt"
          "yq"
          "zig"
          "zls"
          "zoxide"
          "zsh-autosuggestions"
          "zsh-completions"
          "zsh-fast-syntax-highlighting"
          "charmbracelet/tap/freeze"
          "common-fate/granted/granted"
          {
            name = "felixkratz/formulae/borders";
            restart_service = "changed";
            start_service = true;
          }
          "felixkratz/formulae/sketchybar"
          "fluxcd/tap/flux"
          "go-task/tap/go-task"
          "hashicorp/tap/terraform"
          "kluctl/tap/kluctl"
          "nao1215/tap/gup"
          "olets/tap/zsh-abbr"
          "taiki-e/tap/cargo-llvm-cov"
        ];

        casks = [
          "1password-cli"
          "nikitabobko/tap/aerospace"
          "theboredteam/boring-notch/boring-notch"
          "brainfm"
          "claude-code@latest"
          "docker-desktop"
          "font-sf-mono-nerd-font-ligaturized" # not in nixpkgs (custom tap)
          "font-sf-pro" # Apple proprietary, not in nixpkgs
          "ghostty"
          "followtheprocess/tap/git-rekt"
          "goreleaser/tap/goreleaser"
          "followtheprocess/tap/gowc"
          "obsidian"
          "raycast"
          "sf-symbols"
          "slack"
          "followtheprocess/tap/spok"
          "spotify"
          "followtheprocess/tap/tag"
          "followtheprocess/tap/txtract"
          "yaak"
          "zed"
        ];

        masApps = {
          "1Password for Safari" = 1569813296;
          "AdGuard Mini" = 1440147259;
          "Dropover" = 1355679052;
          "JSON Peep" = 1458969831;
          "Kagi for Safari" = 1622835804;
          "Keynote" = 361285480;
          "Noir" = 1592917505;
          "Numbers" = 361304891;
          "Pages" = 361309726;
          "Refined GitHub" = 1519867270;
          "Things" = 904280696;
          "WhatsApp" = 310633997;
          "Xcode" = 497799835;
        };
      };

      # Environment for GUI apps (Aqua session), set via `launchctl setenv`.
      # Replaces the hand-written com.tomfleet.setenv-{path,xdg} launch agents.
      # macOS doesn't source shell rc files for GUI apps, so PATH/XDG must be set
      # here too. Keep the PATH order in sync with .zprofile: nix before brew.
      launchd.user.envVariables =
        let
          home = "/Users/tomfleet";
        in
        {
          PATH = pkgs.lib.concatStringsSep ":" [
            "/run/current-system/sw/bin"        # nix-darwin systemPackages
            "${home}/.nix-profile/bin"          # nix user profile (once added)
            "/nix/var/nix/profiles/default/bin" # nix itself
            "${home}/go/bin"
            "${home}/.bun/bin"
            "${home}/.local/bin"
            "${home}/.cargo/bin"
            "/opt/homebrew/bin"                 # Homebrew, after nix so nix wins
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
      ];
    };
  };
}
