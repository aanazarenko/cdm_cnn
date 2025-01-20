#!/usr/bin/env bash

# Check if the user provided a file path as an argument
if [ -z "$1" ]; then
    echo "Usage: do.sh file_path"
    exit 1
fi

# Get the full file path from the first argument
input_file="$1"

# Extract the file directory, name, and extension
file_dir=$(dirname "$input_file")
file_name=$(basename "$input_file" | sed 's/\(.*\)\..*/\1/')
file_ext="${input_file##*.}"

# Generate the output file path
output_file="${file_dir}/${file_name}_cdmcnn.${file_ext}"

# Run the Python script with the input and output file paths
python3 cdmcnn.py --offset_x=1 --offset_y=1 --input "$input_file" --output "$output_file"

# Run exiftool with the input and output file paths
exiftool -tagsfromfile "$input_file" -overwrite_original "$output_file"