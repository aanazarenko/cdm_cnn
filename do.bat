@echo off
:: Check if the user provided a file path as an argument
if "%~1"=="" (
    echo Usage: do.bat file_path
    exit /b
)

:: Get the full file path from the first argument
set "input_file=%~1"

rem set "saturation=%2"

set "offset_x=%~2"
set "offset_y=%~3"


:: Extract the file directory, name, and extension
for %%F in ("%input_file%") do (
    set "file_dir=%%~dpF"
    set "file_name=%%~nF"
    set "file_ext=%%~xF"
)

set "dcraw_exe=dcraw -v -T -d -4

%dcraw_exe%  "%input_file%"

setlocal ENABLEDELAYEDEXPANSION

set "dcraw_exe_X=%dcraw_exe: =!_!%"

set "exiftool_path=exiftool"

"%exiftool_path%" -d %%Y%%m%%d_%%H%%M -DateTimeOriginal -S -s "%input_file%" > 1.tmp

for /f %%i in (1.tmp) do set photo_date=%%i

echo "%photo_date%"

set "cdmcnn_py=python cdmcnn.py --gpu --linear_input --offset_x=%offset_x% --offset_y=%offset_y%"

:: Generate the output file path
set "output_file=%file_dir%%photo_date%_%file_name%__'%dcraw_exe_X%'__'%cdmcnn_py%'.tiff"

:: Run the Python script with the input and output file paths
%cdmcnn_py% --input "%file_dir%%file_name%.tiff" --output "%output_file%"

"%exiftool_path%" -tagsfromfile "%input_file%" -overwrite_original "%output_file%"