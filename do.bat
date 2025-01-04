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

:: Generate the output file path
set "output_file=%file_dir%%file_name%_cdmcnn%file_ext%"

:: Run the Python script with the input and output file paths
python cdmcnn.py --gpu --offset_x=1 --offset_y=1 --input "%input_file%" --output "%output_file%"