@echo off

set SCRIPT_VERSION=0.1.1

setlocal EnableDelayedExpansion

title Calabash Sandbox
color 0a
cls

echo.
echo Calabash sandbox version: %SCRIPT_VERSION%
echo.

set CALABASH_RUBY_VERSION=ruby-2.1.5-p273
set CALABASH_RUBY_PATH=%USERPROFILE%\.calabash\sandbox\Rubies\%CALABASH_RUBY_VERSION%\bin
set CALABASH_GEM_HOME=%USERPROFILE%\.calabash\sandbox\Gems

set GEM_HOME=%CALABASH_GEM_HOME%
set GEM_PATH=%CALABASH_GEM_HOME%

for %%a in ("%PATH:;=" "%") do (
  set directory=%%a
  set replacedDirectory=!directory:\ruby=!
  if !replacedDirectory!==!directory! (
    if [!CALABASH_SANDBOX_PATH!] == [] (
       set CALABASH_SANDBOX_PATH=%%~a
    ) else (
      set CALABASH_SANDBOX_PATH=!CALABASH_SANDBOX_PATH!;%%~a
    )
  )
)

endlocal & (
  set "PATH=%CALABASH_RUBY_PATH%;%GEM_HOME%\bin;%CALABASH_SANDBOX_PATH%"
  set GEM_HOME=%GEM_HOME%
  set GEM_PATH=%GEM_PATH%
)



