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

rem �I�v�V��������͂���
rem �I�v�V�����͑啶������������ʂł��Ȃ��B
rem
rem [Usage]
rem   set GO_OPTARG=[optarg]
rem   getopt <options> [*]
rem
rem [Output]
rem   �����Ȃ��I�v�V�����̏ꍇ�A�I�v�V�������w�肳��Ă���� GO_OPT_optname �ϐ��� yes ���i�[�����B
rem   ��������I�v�V�����̏ꍇ�A�I�v�V�������w�肳��Ă���� GO_OPT_optname �ϐ��Ɉ����̒l���i�[�����B
rem     ���l��2�d���p���ň͂܂�Ă��Ȃ�
rem   �I�v�V�������w�肳��Ă��Ȃ���Εϐ��͍���Ȃ��B
rem   GO_ARGC �ϐ��ɃI�v�V�����ł͂Ȃ������̐�������B
rem   GO_ARGV1�`GO_ARGV%ARGC% �ϐ��ɃI�v�V�����ł͂Ȃ�����������
rem     ���l��2�d���p���ň͂܂�Ă��Ȃ�
rem

set "GO_OPTARGS=%~1"
if "%GO_OPTARGS%" == "" (
	echo Error: GO_OPTARGS variable is empty.
	exit /b 1
)

setlocal enabledelayedexpansion

rem �c��̈�����S�ă`�F�b�N����
rem GO_ARGC �́@��I�v�V���������̐��𐔂���ϐ�
rem (check_args �̒��Ŏg�p����)
set GO_ARGC=0
rem "%*" �� shift �R�}���h���g�p���Ă��ω����Ȃ��̂ŁAfor ���[�v�����ōŏ��̈����𖳎����邱�Ƃɂ���
set n=0
for %%i in (%*) do (
	if "!n!" GTR "0" call :check_args %%i
	set /a n=n+1
)
endlocal %return%&set "GO_ARGC=%GO_ARGC%"
exit /b 0

rem �����̓��e���`�F�b�N����֐�
:check_args
rem �����ɃA���p�T���h�������Ă��Ă��듮�삵�Ȃ��悤�ɁA2�d���p���ň͂�
set "ARG=%~1"
if "%WAIT_ARG%" == "yes" goto assign_arg
if not "%ARG:~0,1%" == "-" (
	rem �擪���n�C�t���ł͂Ȃ������͒ʏ�̈����Ƃ��Ĉ���
	set /a GO_ARGC=GO_ARGC+1
	set "return=!return!&set GO_ARGV!GO_ARGC!=!ARG:&=^&!"
	goto :EOF
)
rem �擪���n�C�t���Ŏn�܂�������������B
set OPT=%ARG:~1%
rem �������I�v�V���������ꍇ�́A WAIT_ARG �� yes �ɐݒ肵�AWAIT_ARG_NAME �Ɋ��ϐ������i�[����B
rem �������I�v�V��������邩�ǂ����́A OPTARGS �̒��ɃR�������܂܂�Ă��邩�ǂ����Ŕ��肷��
set i=0
:list_args
rem OPTARGS �� i �����ڂ��� 1 ���������o��
rem �p�[�Z���g�L�������q�ɂ��Ă�����q�Ƃ��ĔF������Ȃ��̂ŁA
rem �O�����p�[�Z���g�ŏ�������ɒx�����ϐ��̃G�N�X�N�����[�V�����}�[�N���g���B
set OPTARG=!GO_OPTARGS:~%i%,1!
rem OPTARG ���󕶎���ɂȂ�����AOPTARGS �̗񋓂͏I�������ƌ��Ȃ�
if "%OPTARG%" == "" goto :EOF
if not "%OPT%" == "%OPTARG%" set /a i=i+1& goto list_args
rem OPTARGS �̎��̕������R�����Ȃ�΁A���������I�v�V�����ƌ��Ȃ�
set /a j=i+1
if "!GO_OPTARGS:~%j%,1!" == ":" (
	rem ��������I�v�V�����̂��߁A���̈�����҂�
	set WAIT_ARG=yes
	set WAIT_ARG_NAME=%OPT%
) else (
	rem �R�����ł͂Ȃ��̂ŁA�P�ɒl�� yes �ɐݒ肷��
	set "return=%return%&set GO_OPT_%OPT%=yes"
)
goto :EOF

:assign_arg
set "return=%return%&set GO_OPT_%WAIT_ARG_NAME%=%ARG:&=^&%"
set WAIT_ARG=no
goto :EOF

