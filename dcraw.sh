#!/usr/bin/env bash

# Check if the user provided a file path as an argument
if [ -z "$1" ]; then
    echo "Usage: do.sh file_path"
    exit 1
fi

# Get the full file path from the first argument
input_file="$1"

# Extract the file directory, name, and extension
file_dir="$(dirname "$input_file")/"; echo "$file_dir"
file_name="$(basename "$input_file" | cut -d. -f1)"; echo "$file_name"
file_ext=".${input_file##*.}"; echo "$file_ext"

exiftool_path="exiftool"
dcraw_exe='dcraw -v -w -q 3 -6 -T -o 5 -g 1 1 -c'


# Extract DateTimeOriginal from metadata using exiftool
photo_date=$("$exiftool_path" -d "%Y%m%d_%H%M" -DateTimeOriginal -S -s "$input_file" | tr -d '\r'); echo "$photo_date"

output_file="${file_dir}${photo_date}_${file_name}__'${dcraw_exe}'.tiff"; echo "$output_file"


# Run dcraw
$dcraw_exe "$input_file" > "${output_file}"

# Copy metadata from input to output using exiftool
"$exiftool_path" -tagsfromfile "$input_file" -overwrite_original "$output_file"
