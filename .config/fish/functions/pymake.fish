#!/usr/bin/env fish

function pymake -d "Wrapper around Cpython make with correct compiler flags set."
    argparse --min-args 0 --max-args 1 h/help -- $argv
    or return 1

    if set -q _flag_help
        echo "Wrapper around Cpython make with correct compiler flags set."
        echo
        echo "Usage:"
        echo "  pymake"
        echo
        echo "Flags:"
        echo "  [-h/--help]: Show this help message and exit."
        echo
        return 0
    end

    # Set compilation flags and pass through to make
    set LDFLAGS -L(brew --prefix zlib)/lib -L(brew --prefix bzip2)/lib -L(brew --prefix openssl)/lib -L(brew --prefix readline)/lib

    set CPPFLAGS -I(brew --prefix zlib)/include -I(brew --prefix bzip2)/include

    set CFLAGS -I(brew --prefix openssl)/include -I(brew --prefix bzip2)/include -I(brew --prefix readline)/include -I(xcrun --show-sdk-path)/usr/include

    set_color green
    echo
    echo "Running Cpython make"
    echo
    set_color normal

    echo
    echo "With LDFLAGS: $LDFLAGS"
    echo "CPPFLAGS: $CPPFLAGS"
    echo "CFLAGS: $CFLAGS"
    echo

    make -s -j4

end
