@echo off

rem getopt like command line parser for DOS batch
rem
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

rem オプションを解析する
rem オプションは大文字小文字を区別できない。
rem
rem [Usage]
rem   set GO_OPTARG=[optarg]
rem   getopt <options> [*]
rem
rem [Output]
rem   引数なしオプションの場合、オプションが指定されていれば GO_OPT_optname 変数に yes が格納される。
rem   引数ありオプションの場合、オプションが指定されていれば GO_OPT_optname 変数に引数の値が格納される。
rem     ※値は2重引用符で囲まれていない
rem   オプションが指定されていなければ変数は作られない。
rem   GO_ARGC 変数にオプションではない引数の数が入る。
rem   GO_ARGV1～GO_ARGV%ARGC% 変数にオプションではない引数が入る
rem     ※値は2重引用符で囲まれていない
rem

set "GO_OPTARGS=%~1"
if "%GO_OPTARGS%" == "" (
	echo Error: GO_OPTARGS variable is empty.
	exit /b 1
)

setlocal enabledelayedexpansion

rem 残りの引数を全てチェックする
rem GO_ARGC は　非オプション引数の数を数える変数
rem (check_args の中で使用する)
set GO_ARGC=0
rem "%*" は shift コマンドを使用しても変化しないので、for ループ内部で最初の引数を無視することにする
set n=0
for %%i in (%*) do (
	if "!n!" GTR "0" call :check_args %%i
	set /a n=n+1
)
endlocal %return%&set "GO_ARGC=%GO_ARGC%"
exit /b 0

rem 引数の内容をチェックする関数
:check_args
rem 引数にアンパサンドが入っていても誤動作しないように、2重引用符で囲む
set "ARG=%~1"
if "%WAIT_ARG%" == "yes" goto assign_arg
if not "%ARG:~0,1%" == "-" (
	rem 先頭がハイフンではない引数は通常の引数として扱う
	set /a GO_ARGC=GO_ARGC+1
	set "return=!return!&set GO_ARGV!GO_ARGC!=!ARG:&=^&!"
	goto :EOF
)
rem 先頭がハイフンで始まる引数を見つけた。
set OPT=%ARG:~1%
rem 引数がオプションを取る場合は、 WAIT_ARG を yes に設定し、WAIT_ARG_NAME に環境変数名を格納する。
rem 引数がオプションを取るかどうかは、 OPTARGS の中にコロンが含まれているかどうかで判定する
set i=0
:list_args
rem OPTARGS の i 文字目から 1 文字ずつ取り出す
rem パーセント記号を入れ子にしても入れ子として認識されないので、
rem 外側をパーセントで書く代わりに遅延環境変数のエクスクラメーションマークを使う。
set OPTARG=!GO_OPTARGS:~%i%,1!
rem OPTARG が空文字列になったら、OPTARGS の列挙は終了したと見なす
if "%OPTARG%" == "" goto :EOF
if not "%OPT%" == "%OPTARG%" set /a i=i+1& goto list_args
rem OPTARGS の次の文字がコロンならば、引数を取るオプションと見なす
set /a j=i+1
if "!GO_OPTARGS:~%j%,1!" == ":" (
	rem 引数ありオプションのため、次の引数を待つ
	set WAIT_ARG=yes
	set WAIT_ARG_NAME=%OPT%
) else (
	rem コロンではないので、単に値を yes に設定する
	set "return=%return%&set GO_OPT_%OPT%=yes"
)
goto :EOF

:assign_arg
set "return=%return%&set GO_OPT_%WAIT_ARG_NAME%=%ARG:&=^&%"
set WAIT_ARG=no
goto :EOF

