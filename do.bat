@echo off
:: Check if the user provided a file path as an argument
if "%~1"=="" (
    echo Usage: do.bat file_path
    exit /b
)

:: Get the full file path from the first argument
set "input_file=%~1"

:: Extract the file directory, name, and extension
for %%F in ("%input_file%") do (
    set "file_dir=%%~dpF"
    set "file_name=%%~nF"
    set "file_ext=%%~xF"
)

dcraw -v -D -4 -T "%input_file%"

set "exiftool_path=exiftool"

"%exiftool_path%" -d %%Y%%m%%d_%%H%%M -DateTimeOriginal -S -s "%input_file%" > 1.tmp

for /f %%i in (1.tmp) do set photo_date=%%i

echo "%photo_date%"

:: Generate the output file path
set "output_file=%file_dir%%photo_date%_%file_name%__dcraw(-D_-4_-T)__cdmcnn(lin).tiff"

:: Run the Python script with the input and output file paths
python cdmcnn.py --linear_input --offset_x=1 --offset_y=0 --input "%file_dir%%file_name%.tiff" --output "%output_file%"

"%exiftool_path%" -tagsfromfile "%input_file%" -overwrite_original "%output_file%"