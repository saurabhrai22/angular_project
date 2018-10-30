REM @if "%SCM_TRACE_LEVEL%" NEQ "4" @echo off

REM :: ----------------------
REM :: KUDU Deployment Script
REM :: Version: 1.0.17
REM :: ----------------------

REM :: Prerequisites
REM :: -------------

REM :: Verify node.js installed
REM where node 2>nul >nul
REM IF %ERRORLEVEL% NEQ 0 (
  REM echo Missing node.js executable, please install node.js, if already installed make sure it can be reached from current environment.
  REM goto error
REM )

REM :: Setup
REM :: -----

REM setlocal enabledelayedexpansion

REM SET ARTIFACTS=%~dp0%..\artifacts

REM IF NOT DEFINED DEPLOYMENT_SOURCE (
  REM SET DEPLOYMENT_SOURCE=%~dp0%.
REM )

REM IF NOT DEFINED DEPLOYMENT_TARGET (
  REM SET DEPLOYMENT_TARGET=%ARTIFACTS%\wwwroot
REM )

REM IF NOT DEFINED NEXT_MANIFEST_PATH (
  REM SET NEXT_MANIFEST_PATH=%ARTIFACTS%\manifest

  REM IF NOT DEFINED PREVIOUS_MANIFEST_PATH (
    REM SET PREVIOUS_MANIFEST_PATH=%ARTIFACTS%\manifest
  REM )
REM )

REM IF NOT DEFINED KUDU_SYNC_CMD (
  REM :: Install kudu sync
  REM echo Installing Kudu Sync
  REM call npm install kudusync -g --silent
  REM IF !ERRORLEVEL! NEQ 0 goto error

  REM :: Locally just running "kuduSync" would also work
  REM SET KUDU_SYNC_CMD=%appdata%\npm\kuduSync.cmd
REM )
REM goto Deployment

REM :: Utility Functions
REM :: -----------------

REM :SelectNodeVersion

REM IF DEFINED KUDU_SELECT_NODE_VERSION_CMD (
  REM :: The following are done only on Windows Azure Websites environment
  REM call %KUDU_SELECT_NODE_VERSION_CMD% "%DEPLOYMENT_SOURCE%" "%DEPLOYMENT_TARGET%" "%DEPLOYMENT_TEMP%"
  REM IF !ERRORLEVEL! NEQ 0 goto error

  REM IF EXIST "%DEPLOYMENT_TEMP%\__nodeVersion.tmp" (
    REM SET /p NODE_EXE=<"%DEPLOYMENT_TEMP%\__nodeVersion.tmp"
    REM IF !ERRORLEVEL! NEQ 0 goto error
  REM )
  
  REM IF EXIST "%DEPLOYMENT_TEMP%\__npmVersion.tmp" (
    REM SET /p NPM_JS_PATH=<"%DEPLOYMENT_TEMP%\__npmVersion.tmp"
    REM IF !ERRORLEVEL! NEQ 0 goto error
  REM )

  REM IF NOT DEFINED NODE_EXE (
    REM SET NODE_EXE=node
  REM )

  REM SET NPM_CMD="!NODE_EXE!" "!NPM_JS_PATH!"
REM ) ELSE (
  REM SET NPM_CMD=npm
  REM SET NODE_EXE=node
REM )

REM goto :EOF

REM ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
REM :: Deployment
REM :: ----------

REM :Deployment
REM echo Handling node.js deployment.

REM :: 1. KuduSync
REM IF /I "%IN_PLACE_DEPLOYMENT%" NEQ "1" (
  REM call :ExecuteCmd "%KUDU_SYNC_CMD%" -v 50 -f "%DEPLOYMENT_SOURCE%" -t "%DEPLOYMENT_TARGET%" -n "%NEXT_MANIFEST_PATH%" -p "%PREVIOUS_MANIFEST_PATH%" -i ".git;.hg;.deployment;deploy.cmd"
  REM IF !ERRORLEVEL! NEQ 0 goto error
REM )

REM :: 2. Select node version
REM call :SelectNodeVersion

REM :: 3. Install npm packages
REM IF EXIST "%DEPLOYMENT_TARGET%\package.json" (
  REM pushd "%DEPLOYMENT_TARGET%"
  REM call :ExecuteCmd !NPM_CMD! install --production
  REM IF !ERRORLEVEL! NEQ 0 goto error
  REM popd
REM )

REM ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
REM goto end

REM :: Execute command routine that will echo out when error
REM :ExecuteCmd
REM setlocal
REM set _CMD_=%*
REM call %_CMD_%
REM if "%ERRORLEVEL%" NEQ "0" echo Failed exitCode=%ERRORLEVEL%, command=%_CMD_%
REM exit /b %ERRORLEVEL%

REM :error
REM endlocal
REM echo An error has occurred during web site deployment.
REM call :exitSetErrorLevel
REM call :exitFromFunction 2>nul

REM :exitSetErrorLevel
REM exit /b 1

REM :exitFromFunction
REM ()

REM :end
REM endlocal
REM echo Finished successfully.

REM New Code


@if "%SCM_TRACE_LEVEL%" NEQ "4" @echo off

:: ----------------------
:: KUDU Deployment Script
:: Version: 1.0.8
:: ----------------------

:: Prerequisites
:: -------------

:: Verify node.js installed
where node 2>nul >nul
IF %ERRORLEVEL% NEQ 0 (
  echo Missing node.js executable, please install node.js, if already installed make sure it can be reached from current environment.
  goto error
)

:: Setup
:: -----

setlocal enabledelayedexpansion

SET ARTIFACTS=%~dp0%..\artifacts

IF NOT DEFINED DEPLOYMENT_SOURCE (
  SET DEPLOYMENT_SOURCE=%~dp0%.
)

IF NOT DEFINED DEPLOYMENT_TARGET (
  SET DEPLOYMENT_TARGET=%ARTIFACTS%\wwwroot
)

IF NOT DEFINED NEXT_MANIFEST_PATH (
  SET NEXT_MANIFEST_PATH=%ARTIFACTS%\manifest

  IF NOT DEFINED PREVIOUS_MANIFEST_PATH (
    SET PREVIOUS_MANIFEST_PATH=%ARTIFACTS%\manifest
  )
)

IF NOT DEFINED KUDU_SYNC_CMD (
  :: Install kudu sync
  echo Installing Kudu Sync
  call npm install kudusync -g --silent
  IF !ERRORLEVEL! NEQ 0 goto error

  :: Locally just running "kuduSync" would also work
  SET KUDU_SYNC_CMD=%appdata%\npm\kuduSync.cmd
)
goto Deployment

:: Utility Functions
:: -----------------

:SelectNodeVersion

IF DEFINED KUDU_SELECT_NODE_VERSION_CMD (
  :: The following are done only on Windows Azure Websites environment
  call %KUDU_SELECT_NODE_VERSION_CMD% "%DEPLOYMENT_SOURCE%" "%DEPLOYMENT_TARGET%" "%DEPLOYMENT_TEMP%"
  IF !ERRORLEVEL! NEQ 0 goto error

  IF EXIST "%DEPLOYMENT_TEMP%\__nodeVersion.tmp" (
    SET /p NODE_EXE=<"%DEPLOYMENT_TEMP%\__nodeVersion.tmp"
    IF !ERRORLEVEL! NEQ 0 goto error
  )

  IF EXIST "%DEPLOYMENT_TEMP%\__npmVersion.tmp" (
    SET /p NPM_JS_PATH=<"%DEPLOYMENT_TEMP%\__npmVersion.tmp"
    IF !ERRORLEVEL! NEQ 0 goto error
  )

  IF NOT DEFINED NODE_EXE (
    SET NODE_EXE=node
  )

  SET NPM_CMD="!NODE_EXE!" "!NPM_JS_PATH!"
) ELSE (
  SET NPM_CMD=npm
  SET NODE_EXE=node
)

goto :EOF

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Deployment
:: ----------

:Deployment
echo Handling node.js deployment.

:: 1. KuduSync
IF /I "%IN_PLACE_DEPLOYMENT%" NEQ "1" (
  call :ExecuteCmd "%KUDU_SYNC_CMD%" -v 50 -f "%DEPLOYMENT_SOURCE%" -t "%DEPLOYMENT_TARGET%" -n "%NEXT_MANIFEST_PATH%" -p "%PREVIOUS_MANIFEST_PATH%" -i ".git;.hg;.deployment;deploy.cmd"
  IF !ERRORLEVEL! NEQ 0 goto error
)

:: 2. Select node version
call :SelectNodeVersion

:: 3. Install npm packages
IF EXIST "%DEPLOYMENT_TARGET%\package.json" (
  pushd "%DEPLOYMENT_TARGET%"
  call :ExecuteCmd !NPM_CMD! install --only=prod
  IF !ERRORLEVEL! NEQ 0 goto error
  popd
)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
goto end

:: Execute command routine that will echo out when error
:ExecuteCmd
setlocal
set _CMD_=%*
call %_CMD_%
if "%ERRORLEVEL%" NEQ "0" echo Failed exitCode=%ERRORLEVEL%, command=%_CMD_%
exit /b %ERRORLEVEL%

:error
endlocal
echo An error has occurred during web site deployment.
call :exitSetErrorLevel
call :exitFromFunction 2>nul

:exitSetErrorLevel
exit /b 1

:exitFromFunction
()

:end
endlocal
echo Finished successfully.