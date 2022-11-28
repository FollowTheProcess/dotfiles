#!/usr/bin/env fish

function pyenv_install -d "Wrapper around pyenv install with compile flags set."
    argparse --min-args 0 --max-args 1 h/help -- $argv
    or return 1

    if set -q _flag_help
        echo "Wrapper around 'pyenv install' with compile flags set."
        echo
        echo "Only 1 argument is taken, a valid pyenv python version."
        echo
        echo "Usage:"
        echo "  pyenv_install <python version>"
        echo
        echo "Flags:"
        echo "  [-h/--help]: Show this help message and exit."
        echo
        return 0
    end

    # Set compilation flags and pass through to real pyenv
    set LDFLAGS -L(brew --prefix zlib)/lib -L(brew --prefix xz)/lib -L(brew --prefix bzip2)/lib -L(brew --prefix openssl)/lib -L(brew --prefix readline)/lib

    set CPPFLAGS -I(brew --prefix zlib)/include -I(brew --prefix bzip2)/include -I(brew --prefix xz)/include

    set CFLAGS -I(brew --prefix openssl)/include -I(brew --prefix xz)/include -I(brew --prefix bzip2)/include -I(brew --prefix readline)/include -I(xcrun --show-sdk-path)/usr/include

    set_color green
    echo
    echo "Installing python $argv[1]"
    echo
    set_color normal

    echo
    echo "With LDFLAGS: $LDFLAGS"
    echo "CPPFLAGS: $CPPFLAGS"
    echo "CFLAGS: $CFLAGS"
    echo

    pyenv install $argv[1]

end
