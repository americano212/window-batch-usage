@echo off
chcp 65001 > nul
setlocal EnableDelayedExpansion

for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set datetime=%%a
set "startDate=!datetime:~0,4!-!datetime:~4,2!-!datetime:~6,2!_!datetime:~8,2!-!datetime:~10,2!-!datetime:~12,2!"
set "filename=result_%startDate%.log"

echo Ping Test 시작 - !startDate! >> %filename%
echo Ping Test 시작 - !startDate!
echo.

set "cycleCount=0"
set "maxAttempts=3"

:while_loop

set "successCount=0"
set "failureCount=0"
echo ==================================================

for /f "tokens=1,*" %%i in (ip.txt) do (
    set ip=%%i
    set server=%%j
    set "output="
    set "failureAttempts=0"

    for /L %%a in (1,1,%maxAttempts%) do (
        for /f "delims=" %%k in ('ping -n 1 !ip! ^| find "TTL"') do set output=성공

        if not defined output (
            set /a failureAttempts+=1
        )
        timeout /t 1 > nul
    )

    if !failureAttempts! equ %maxAttempts% (
        set output=실패
        set /a failureCount+=1
    ) else (
        set /a successCount+=1
    )
    set "failureAttempts=0"
    echo !ip! - !output!  >> %filename%
    echo !ip!	- !server!	- !output!
)

set /a cycleCount+=1

for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set datetime=%%a
set "endDate=!datetime:~0,4!-!datetime:~4,2!-!datetime:~6,2! !datetime:~8,2!:!datetime:~10,2!:!datetime:~12,2!"

echo.
echo %cycleCount%회차 종료	- !endDate! >> %filename%
echo %cycleCount%회차 종료	- !endDate!
echo 성공: %successCount%, 실패: %failureCount%
echo.

timeout /t 1 > nul
goto while_loop
