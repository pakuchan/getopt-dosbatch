@echo off

rem Copyright (c) 2015 Pakuchan.
rem
rem Permission is hereby granted, free of charge, to any person obtaining a copy of
rem this software and associated documentation files (the "Software"), to deal in
rem the Software without restriction, including without limitation the rights to
rem use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
rem the Software, and to permit persons to whom the Software is furnished to do so,
rem subject to the following conditions:
rem
rem The above copyright notice and this permission notice shall be included in all
rem copies or substantial portions of the Software.
rem
rem THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
rem IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
rem FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
rem COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
rem IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
rem CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

call getopt_test_wrapper.bat "" >NUL
call :is_equal "%ERRORLEVEL%" 1 "Checking whether getopt returns an error with empty OPTARGS variable"

call getopt_test_wrapper.bat "a:bcd:efg" -a -b -c -d "e&f" "ghi jkl" "mno&pqr" <NUL
call :is_equal "%ERRORLEVEL%" 0 "Checking whether getopt finishes with no error"
call :is_equal2 "%GO_ARGC%" "2" "GO_ARGC"
call :is_equal2 "%GO_OPT_a%" "-b" "GO_OPT_a"
call :is_equal2 "%GO_OPT_c%" "yes" "GO_OPT_c"
call :is_equal2 "%GO_OPT_d%" "e&f" "GO_OPT_d"
call :is_equal2 "%GO_ARGV1%" "ghi jkl" "GO_ARGV1"
call :is_equal2 "%GO_ARGV2%" "mno&pqr" "GO_ARGV2"

pause
goto :EOF

rem is_equal [actual] [expected] [message]
:is_equal
set /p "__tmp=%~3...  " <NUL
if "%~1" == "%~2" (
	echo OK
) else (
	echo Fail. ^(expected=%~2, actual=%~1^)
)
goto :EOF

rem is_equal2 [actual] [expected] [value name]
:is_equal2
call :is_equal "%~1" "%~2" "Checking whether the value of %~3 should be %~2"
goto :EOF


