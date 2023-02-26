#!/usr/bin/env python3

"""
Helper invoked by the `pod` fish function to create a new branch for a
POD Jira ticket.


Author: Tom Fleet
Created: 18/02/2023
"""

from __future__ import annotations

import argparse
import subprocess
import sys
from enum import Enum

__version__ = "0.1.0"


class Branch(Enum):
    """
    All allowed branch types
    """

    FIX = "fix"
    FEATURE = "feature"
    HOTFIX = "hotfix"
    RELEASE = "release"
    CI = "ci"
    DOCS = "docs"
    CHORE = "chore"
    STYLE = "style"
    REFACTOR = "refactor"
    PERF = "perf"
    DEPS = "dependencies"

    def __str__(self) -> str:
        return self.value


class Args:
    __slots__ = ("branch", "ticket", "dry_run")

    def __init__(self, branch: Branch, ticket: str, dry_run: bool) -> None:
        self.branch = branch
        self.ticket = ticket
        self.dry_run = dry_run

    def __repr__(self) -> str:
        return (
            self.__class__.__qualname__
            + f"(branch={self.branch!r}, ticket={self.ticket!r},"
            f" dry_run={self.dry_run!r})"
        )

    def __str__(self) -> str:
        return f"{self.branch}/POD-{self.ticket}"

    @staticmethod
    def parse(argv: list[str]) -> Args:
        """
        Parse the arguments passed into an Args object.
        """
        parser = argparse.ArgumentParser(prog="pod", description=__doc__)
        group = parser.add_argument_group(
            "branch", "The type of branch to create (mutually exclusive)"
        )
        exclusive_group = group.add_mutually_exclusive_group()

        parser.add_argument(
            "ticket",
            action="store",
            type=str,
            help="The POD ticket number",
            nargs=1,
        )
        exclusive_group.add_argument(
            "-F",
            "--fix",
            action="store_const",
            const=Branch.FIX,
            dest="branch",
            help="Create as a bug fix branch",
        )
        exclusive_group.add_argument(
            "-f",
            "--feat",
            action="store_const",
            const=Branch.FEATURE,
            dest="branch",
            help="Create as a feature branch (default)",
        )
        exclusive_group.add_argument(
            "-H",
            "--hotfix",
            action="store_const",
            const=Branch.HOTFIX,
            dest="branch",
            help="Create as a hotfix branch",
        )
        exclusive_group.add_argument(
            "-r",
            "--release",
            action="store_const",
            const=Branch.RELEASE,
            dest="branch",
            help="Create as a release branch",
        )
        exclusive_group.add_argument(
            "-c",
            "--ci",
            action="store_const",
            const=Branch.CI,
            dest="branch",
            help="Create as a CI branch",
        )
        exclusive_group.add_argument(
            "-d",
            "--docs",
            action="store_const",
            const=Branch.DOCS,
            dest="branch",
            help="Create as a docs branch",
        )
        exclusive_group.add_argument(
            "-C",
            "--chore",
            action="store_const",
            const=Branch.CHORE,
            dest="branch",
            help="Create as a chore branch",
        )
        exclusive_group.add_argument(
            "-s",
            "--style",
            action="store_const",
            const=Branch.STYLE,
            dest="branch",
            help="Create as a style branch",
        )
        exclusive_group.add_argument(
            "-R",
            "--refactor",
            action="store_const",
            const=Branch.REFACTOR,
            dest="branch",
            help="Create as a refactor branch",
        )
        exclusive_group.add_argument(
            "-p",
            "--perf",
            action="store_const",
            const=Branch.PERF,
            dest="branch",
            help="Create as a performance branch",
        )
        exclusive_group.add_argument(
            "-D",
            "--deps",
            action="store_const",
            const=Branch.DEPS,
            dest="branch",
            help="Create as a dependency branch",
        )
        parser.add_argument(
            "-n",
            "--dry-run",
            action="store_true",
            help="Print the name of the branch rather than create it",
            dest="dry_run",
            default=False,
        )
        parser.add_argument(
            "-v",
            "--version",
            action="version",
            version=f"%(prog)s {__version__}",
        )

        args = parser.parse_args(argv)

        return Args(
            branch=args.branch or Branch.FEATURE,
            ticket=args.ticket[0],
            dry_run=args.dry_run,
        )

    def create(self) -> None:
        """
        Create the branch
        """
        if self.dry_run:
            print(f"Create branch: {self}")
            return

        subprocess.run(
            ["git", "switch", "--create", f"{self}"],
            check=True,
            stdout=sys.stdout,
            stderr=sys.stderr,
        )


def main(argv: list[str]) -> None:
    """
    Entry point for the script
    """
    args = Args.parse(argv=argv)
    args.create()


if __name__ == "__main__":
    main(sys.argv[1:])
