#!/usr/bin/env fish


# Automatically detect or create the correct virtual environment
function venv -d "Auto detects or creates an appropriate python virtual environment."
    argparse --min-args 0 --max-args 0 h/help -- $argv
    or return 1

    if set -q _flag_help
        echo "Automatically detects or creates fresh python virtual environments"
        echo "Looks at the files you have in your current directory to decide what to do"
        echo
        echo "Usage:"
        echo "  venv"
        echo
        echo "Flags:"
        echo "  [-h/--help]: Show this help message and exit."
        echo
        return 0
    end

    if [ -d ".venv" ]
        # If a venv directory exists, a venv has already been created
        # and therefore shouldn't be messed with
        # All we do here is activate it and set VSCode up
        set_color cyan
        echo ".venv directory found. Activating venv..."
        set_color normal
        # If it's a hatch one, it will have a .venv/project_name/bin/activate.fish
        if [ -f .venv/(path basename $PWD)/bin/activate.fish ]
            source .venv/(path basename $PWD)/bin/activate.fish
        else
            source .venv/bin/activate.fish
        end

    else if [ -d venv ]
        # Incase there is a directory called venv, just activate it
        set_color cyan
        echo "venv directory found. Activating venv..."
        set_color normal
        # Activate it
        source venv/bin/activate.fish

    else if [ -f "requirements-dev.txt" ]
        # If no venv folder but a requirements.txt, project must use venv and not conda
        # Prefer requirements-dev as it will have everything
        set_color cyan
        echo "Found requirements-dev.txt. Installing dependencies..."
        set_color normal
        echo "Creating new environment with venv..."

        # Create the new environment
        virtualenv .venv

        source .venv/bin/activate.fish

        # Update and install stuff
        python -m pip install -r requirements-dev.txt


    else if [ -f "requirements.txt" ]
        # Fall back to requirements.txt
        set_color cyan
        echo "Found requirements.txt. Installing dependencies..."
        set_color normal
        echo "Creating new environment with venv..."

        # Create the new environment
        virtualenv .venv

        source .venv/bin/activate.fish

        # Update and install stuff
        python -m pip install -r requirements.txt


    else if [ -f "pyproject.toml" ]
        # PEP517/518 requires use of pyproject.toml
        # Could be a different build system so we have to check
        if [ -f "setup.cfg" ] || [ -f "setup.py" ]
            # We must be using setuptools
            set_color cyan
            echo "Creating a PEP517 compatible venv for setuptools..."
            echo
            set_color normal

            # Create the new environment
            # no longer need to activate if using `py`
            virtualenv .venv
            source .venv/bin/activate.fish

            set_color cyan
            echo "Installing project dependencies (PEP 517)..."
            echo
            set_color normal

            set_color cyan
            echo "Installing with 'pip install -e .[dev]'..."
            echo
            set_color normal

            python -m pip install -e .[dev]

            set_color green

            echo "Environment created (PEP517) (venv)"
            echo
            set_color normal

        else
            set_color cyan
            echo "Found 'pyproject.toml' without a setuptools file (either 'setup.cfg' or 'setup.py')"
            set_color normal

            read -P "Which build tool does this project use [flit|poetry|pip]: " build_tool

            switch "$build_tool"

                case poetry
                    # Poetry handles all of this
                    poetry install

                    source .venv/bin/activate.fish

                case flit
                    # With flit we have to do a bit more work
                    set_color cyan
                    echo "Creating PEP517 compatible venv for flit..."
                    echo
                    set_color normal

                    # Create the new environment
                    virtualenv .venv
                    source .venv/bin/activate.fish

                    # This is flit's equivalent of pip install -e .[dev]
                    flit install --deps develop --symlink --python .venv/bin/python

                case pip
                    set_color cyan
                    echo "Creating PEP517 compatible venv for pip..."
                    echo
                    set_color normal

                    virtualenv .venv
                    source .venv/bin/activate.fish

                    python -m pip install -e .[dev]

                case "*"
                    set_color red
                    echo "Invalid option: Please answer 'flit', 'poetry', or 'pip'"
                    set_color normal
            end

            set_color green
            echo "Environment created (PEP517) ($build_tool)"
            set_color normal

        end

    else if [ -f "environment.yml" ]
        # We must have a conda environment
        set_color cyan
        echo "Found 'environment.yml'. Checking if conda environment already exists on system..."
        echo
        set_color normal

        set envname (cat environment.yml | grep -w name: | cut -d':' -f 2 | xargs)

        if conda env list | grep -qFe "$envname"
            # This means the conda env already exists on the system
            # all we have to do is activate it
            set_color cyan
            echo "Conda env: $envname exists on system. Activating..."
            echo
            set_color normal
            conda activate "$envname"
        else
            # This means it doesn't exist on the system
            set_color yellow
            echo "Conda env $envname not found on system"

            set_color cyan
            echo "Creating new conda env: $envname from yml file..."
            echo
            set_color normal

            conda env create --file environment.yml

            conda activate "$envname"

            if [ -f .vscode/settings.json ]
                set_color yellow
                echo "VSCode settings already exist, not overwriting."
                set_color normal
            else
                mkdir -p .vscode
                touch .vscode/settings.json

                echo "{\"python.defaultInterpreterPath\": \"$condaenvs/$envname/bin/python\"}" >.vscode/settings.json
            end

            set_color green
            echo "Environment: $envname created (conda)"
            echo
            set_color normal
        end

    else
        # Means there's no environment at all yet
        # Given that we've called 'venv' we must want to create one
        set_color yellow
        echo "Can't detect any venv or conda environment for this project."
        set_color normal


        set_color cyan
        echo "Creating new environment with venv..."
        echo
        set_color normal

        virtualenv .venv
        source .venv/bin/activate.fish

        set_color green
        echo "Fresh environment created (venv)"
        echo
        set_color normal
    end
end
