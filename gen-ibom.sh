#!/bin/sh

#
# Usage: ./gen-ibom.sh <pcb> <new ibom location>
#
# Generates an interactive HTML BOM for the provided PCB
#

set -e

start_dir="$(pwd)"

die() {
    echo "$*"
    exit 1
}

if [ $# -ne 2 ]; then
    die "Usage: $0 <pcb> <new ibom location>"
fi

pcb="$1"
ext="$(basename "$pcb" | sed 's/^.*\.\(.*\)$/\1/')"
[ "$ext" = "kicad_pcb" ] || die "File extension must be 'kicad_pcb'"
[ -f "$pcb" ] || die "PCB '$pcb' doesn't exist"

new_location="$2"
[ -z "$new_location" ] && die "Invalid (empty) location for new iBOM: '$new_location'"
echo "$new_location" | grep ".html$" >/dev/null || die "New iBOM name should end in .html, not '$new_location'"

dir="$(dirname "$new_location")"
[ -z "$dir" ] || mkdir -p "$dir"
name_format="$(basename "$new_location" | sed 's/\(.*\)\.html/\1/')"

INTERACTIVE_HTML_BOM_NO_DISPLAY=1 generate_interactive_bom --include-nets "$pcb" --dest-dir "$start_dir/$dir" --no-browser --name-format "$name_format"
