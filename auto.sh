#!/bin/bash
set -e

DUMP_DIR="dump"
mkdir -p "$DUMP_DIR"

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <file1.s|file1.asm> [file2.s|file2.asm ...]"
    exit 1
fi

# First source = main one we assemble
SRC_MAIN="$1"
EXT="${SRC_MAIN##*.}"
BASE=$(basename "$SRC_MAIN" ".$EXT")
OBJ_MAIN="$DUMP_DIR/$BASE.o"
BIN="$DUMP_DIR/$BASE"

# Remaining sources (if any)
shift
EXTRA_SRCS=("$@")

# Assemble main file
if [ "$EXT" == "asm" ]; then
    echo -e "\033[1;34m[+] NASM mode...\033[0m"
    nasm -f elf64 "$SRC_MAIN" -o "$OBJ_MAIN"
elif [ "$EXT" == "s" ]; then
    echo -e "\033[1;34m[+] GAS mode...\033[0m"
    as --64 "$SRC_MAIN" -o "$OBJ_MAIN"
else
    echo -e "\033[1;31m[-] Unknown extension: .$EXT\033[0m"
    exit 1
fi

# Assemble or prepare other .s/.asm files as objects
EXTRA_OBJS=()
for SRC in "${EXTRA_SRCS[@]}"; do
    EXT="${SRC##*.}"
    BASE=$(basename "$SRC" ".$EXT")
    OBJ="$DUMP_DIR/$BASE.o"

    if [ "$EXT" == "asm" ]; then
        nasm -f elf64 "$SRC" -o "$OBJ"
    elif [ "$EXT" == "s" ]; then
        as --64 "$SRC" -o "$OBJ"
    else
        echo -e "\033[1;33m[!] Skipping unknown file type: $SRC\033[0m"
        continue
    fi

    EXTRA_OBJS+=("$OBJ")
done

# Link everything together
echo -e "\033[1;36m[*] Linking...\033[0m"
ld "$OBJ_MAIN" "${EXTRA_OBJS[@]}" -o "$BIN"

echo -e "\033[1;32m[✓] Build successful!\033[0m"
echo "Output: $BIN"

