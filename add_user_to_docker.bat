@echo off
setlocal EnableDelayedExpansion

echo Local User Accounts:
echo -------------------

set i=1

REM This loop uses the "wmic" command to iterate through the list of local user accounts on the system. The loop skips the first line of output,
REM which contains the column header, and then stores each subsequent line in a variable named "user[i]". The variable "i" is incremented with each iteration of the loop.
for /f "skip=1" %%U in ('wmic useraccount where "LocalAccount='TRUE' and Disabled='FALSE' and Lockout='FALSE'" get name') do (
    set "user[!i!]=%%U"
    echo !i!. %%U
    set /a i+=1
)

echo -------------------

REM This section prompts the user to select an account from the list of local user accounts, and retrieves the associated username from the "user" array.
set /p selection=Enter the number of the account you want to add to the Docker group: 

set username=!user[%selection%]!

REM If the selected user account is not found, an error message is displayed and the script exits.
if not defined username (
    echo Invalid selection. Please try again.
    pause
    exit /b 1
)

REM The "net localgroup" command is used to add the selected user to the "docker-users" group.
net localgroup docker-users %username% /add

REM A confirmation message is displayed, and the script waits for the user to press a key before exiting.
echo The account %username% has been added to the Docker group.
pause

REM This script was created by Sangeeth Kumar Vasudevan - sangeethkumarvm@gmail.com
