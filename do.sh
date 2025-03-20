#!/usr/bin/env bash

# Check if the user provided a file path as an argument
if [ -z "$1" ]; then
    echo "Usage: do.sh file_path"
    exit 1
fi

# Get the full file path from the first argument
input_file="$1"
offset_x="$2"
offset_y="$3"

# Extract the file directory, name, and extension
file_dir="$(dirname "$input_file")/"; echo "$file_dir"
file_name="$(basename "$input_file" | cut -d. -f1)"; echo "$file_name"
file_ext=".${input_file##*.}"; echo "$file_ext"

dcraw_exe="dcraw -v -T -d -4"

# Run dcraw
$dcraw_exe "$input_file"

# Extract DateTimeOriginal from metadata using exiftool
exiftool_path="exiftool"
photo_date=$("$exiftool_path" -d "%Y%m%d_%H%M" -DateTimeOriginal -S -s "$input_file" | tr -d '\r'); echo "$photo_date"

cdmcnn_py="python cdmcnn.py --linear_input --offset_x=$offset_x --offset_y=$offset_y"

# Generate the output file path
output_file="${file_dir}${photo_date}_${file_name}__'${dcraw_exe//' '/'_'}'__'${cdmcnn_py//' '/'_'}'.tiff"; echo "$output_file"

# Run the Python script with the input and output file paths
$cdmcnn_py --input "${file_dir}${file_name}.tiff" --output "$output_file"

# Copy metadata from input to output using exiftool
"$exiftool_path" -tagsfromfile "$input_file" -overwrite_original "$output_file"
