# Custom commands as a nu module

# mk creates a new directory then cd's into it.
def mk [
    path: string # The path to the directory to make
] {
    mkdir $path; cd $path
}
