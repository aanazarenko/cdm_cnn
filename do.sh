#!/usr/bin/env bash

# Check number of arguments
if [ $# -lt 3 ] || [ $# -gt 4 ]; then
    echo "Usage: do.sh file_path offset_x offset_y [python_version]"
    exit 1
fi

# Check if the first argument is an existing file
if [ ! -f "$1" ]; then
    echo "Error: '$1' is not a valid file."
    exit 2
fi

# Check if the second argument is a number
if ! [[ "$2" =~ ^-?[0-9]+$ ]]; then
    echo "Error: offset_x ('$2') is not a valid number."
    exit 1
fi

# Check if the third argument is a number
if ! [[ "$3" =~ ^-?[0-9]+$ ]]; then
    echo "Error: offset_y ('$3') is not a valid number."
    exit 1
fi

# Check if the fourth argument (python_version) is provided and valid
if [ -n "$4" ] && ! [[ "$4" =~ ^3\.1[0-9]$ ]]; then
    echo "Error: python_version ('$4') must be in format '3.1X' where X is 0-9."
    exit 1
fi


# Take from arguments 
input_file="$1"
offset_x="$2"
offset_y="$3"
python_version="${4:-3.11}"


# Show requirements
python_exe="python${python_version}"

${python_exe} 'show_requirements.py'

# In case the requirements are not satisfied, we try to install them all using `pip`
if [ $? -ne 0 ]; then
    
    echo "Python modules requirements are not satisfied, we will try to install them all."
    
    # Install the requirements using `pip`
    python_pip_exe="pip${python_version}"
    ${python_pip_exe} install torch numpy tqdm scikit-image hdf5storage

    # Re-run 
    ${python_exe} 'show_requirements.py'

fi


# Extract the file directory, name, and extension
file_dir="$(dirname "$input_file")/"; echo "$file_dir"
file_name="$(basename "$input_file" | cut -d. -f1)"; echo "$file_name"
file_ext=".${input_file##*.}"; echo "$file_ext"


# Run dcraw
dcraw_exe="dcraw -v -T -d -4"
${dcraw_exe} "$input_file"


exiftool_path='exiftool'

# Extract DateTimeOriginal from metadata using exiftool
photo_date=$("$exiftool_path" -d "%Y%m%d_%H%M" -DateTimeOriginal -S -s "$input_file" | tr -d '\r'); echo "$photo_date"

cdmcnn_py="${python_exe} cdmcnn.py --gpu --linear_input --offset_x=$offset_x --offset_y=$offset_y"

# Generate the output file path
output_file="${file_dir}${photo_date}_${file_name}__'${dcraw_exe//' '/_}'__'${cdmcnn_py//' '/_}'.tiff"; echo "$output_file"


# Run the Python script with the input and output file paths
${cdmcnn_py} --input "${file_dir}${file_name}.tiff" --output "$output_file"


# Copy metadata from input to output using exiftool
${exiftool_path} -tagsfromfile "$input_file" -overwrite_original "$output_file"