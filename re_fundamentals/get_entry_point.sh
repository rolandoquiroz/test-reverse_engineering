#!/bin/bash

# Source the reusable message function
source messages.sh

# Check for argument
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <ELF file>"
    exit 1
fi

file_name="$1"

# Check if file exists
if [[ ! -f "$file_name" ]]; then
    echo "Error: File '$file_name' does not exist."
    exit 1
fi

# Check if it's an ELF file (first 4 bytes should be: 0x7f 45 4c 46)
magic_bytes=$(head -c 4 "$file_name" | hexdump -v -e '/1 "%02x "')
if [[ "$magic_bytes" != "7f 45 4c 46 " ]]; then
    echo "Error: '$file_name' is not a valid ELF file."
    exit 1
fi

# Extract values from ELF header using readelf
magic_number=$(hexdump -n 4 -v -e '4/1 "%02x"' "$file_name")
class=$(readelf -h "$file_name" | awk -F: '/Class:/ {gsub(/ /,"",$2); print $2}')
byte_order=$(readelf -h "$file_name" | awk -F: '/Data:/ {print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')
entry_point_address=$(readelf -h "$file_name" | awk -F: '/Entry point address:/ {print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')

# Call the message function to display results
display_elf_header_info
