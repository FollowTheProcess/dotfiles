#!/usr/bin/env python3

"""
Helper script called by the "maintenance" fish function that checks if ~/Downloads
is empty, if not it deletes everything in there.


Author: Tom Fleet
Created: 25/09/2022
"""

from __future__ import annotations

import sys
from gc import is_finalized
from pathlib import Path

DOWNLOADS = Path.home().joinpath("Downloads").resolve()


def main() -> int:
    """
    Main script routine

    Returns:
        int: Exit code
    """
    # Can't just do shutil.rmtree or similar because ~/Downloads is protected
    # so instead just loop through the contents and delete each one
    status_code: int = 0
    for item in DOWNLOADS.iterdir():
        try:
            match item.is_dir():
                case True:
                    item.rmdir()
                case False:
                    item.unlink()
        except Exception as err:
            print(f"Could not delete {item}: {err}")
            status_code = 1
            break

    return status_code


if __name__ == "__main__":
    sys.exit(main())
