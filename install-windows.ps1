function Expand-ZIPFile($file, $destination)
{
    $shell = new-object -com shell.application
    $zip = $shell.NameSpace($file)
    foreach($item in $zip.items())
    {
        $shell.Namespace($destination).copyhere($item, 0x14)
    }
}

$ErrorActionPreference = "Stop"

$sandbox="${env:USERPROFILE}\.calabash\sandbox"
$calabashRubiesHome="${sandbox}\Rubies"
$calabashRubyVersion="ruby-2.1.5-p273"
$calabashRubyPath="${calabashRubiesHome}\${calabashRubyVersion}\bin"
$calabashSandboxBin="${sandbox}\bin"
$calabashSandboxBat="${calabashSandboxBin}\calabash-sandbox.bat"

$env:GEM_HOME="${sandbox}\Gems"
$env:GEM_PATH="${env:GEM_HOME};${calabashRubiesHome}\${calabashRubyVersion}\lib\ruby\gems\2.1.0\gems\"

#Don't auto-overwrite the sandbox if it already exists
if (Test-Path $sandbox)
{
    $title = "Overwrite Sandbox"
    $message = "Sandbox already exists! Do you want to overwrite?"
	
    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
        "Replaces the $sandbox folder"

    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
        "Exists this script."

    $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

    $result = $host.ui.PromptForChoice($title, $message, $options, 1) 

    switch ($result)
    {
        1 {
            Write-Host ""            
            Write-Host "Not overwriting ${sandbox}, exiting..."
            exit 0 
        }
    }
}

if (!(Test-Path $env:GEM_HOME))
{
    New-Item $env:GEM_HOME -type directory | Out-Null
}
if (!(Test-Path $calabashRubiesHome))
{
    New-Item $calabashRubiesHome -type directory | Out-Null
}
if (!(Test-Path $calabashSandboxBin))
{
    New-Item $calabashSandboxBin -type directory | Out-Null
}

#Download Ruby
Write-Host "Preparing Ruby ${calabashRubyVersion}..."
$currentDirectory = (Resolve-Path .\).Path
$rubyDownloadFile = "$currentDirectory\${calabashRubyVersion}-win32.zip"
wget https://s3-eu-west-1.amazonaws.com/calabash-files/calabash-sandbox/windows/ruby-2.1.5-p273-win32.zip -OutFile $rubyDownloadFile
Expand-ZIPFile $rubyDownloadFile $calabashRubiesHome
Remove-Item $rubyDownloadFile

#Download the gems and their dependencies
Write-Host "Installing gems, this may take a little while..."
$gemsDownloadFile = "$currentDirectory\CalabashGems-win32.zip"
wget https://s3-eu-west-1.amazonaws.com/calabash-files/calabash-sandbox/windows/CalabashGems-win32.zip -OutFile $gemsDownloadFile
Expand-ZIPFile $gemsDownloadFile $sandbox
Remove-Item $gemsDownloadFile

#Download the Sandbox Script
Write-Host "Preparing sandbox..."
wget https://s3-eu-west-1.amazonaws.com/calabash-files/calabash-sandbox/windows/calabash-sandbox.bat -OutFile $calabashSandboxBat

$pathParts = New-Object System.Collections.Generic.List[string]
$pathParts.AddRange($env:PATH.Split(";", [System.StringSplitOptions]::RemoveEmptyEntries))

# Remove any ruby bin folders from the path
Foreach ($dir in $pathParts.ToArray())
{
    if (Test-Path "$dir\ruby.exe")
    {
        $pathParts.Remove($dir) | Out-Null
    }
}

# Add the calabash bin folder to the path
if (!($pathParts.Contains($calabashSandboxBin)))
{
    $pathParts.Add($calabashSandboxBin)
}

# Add the ruby bin folder to the path
if (!($pathParts.Contains($calabashRubyPath)))
{
    $pathParts.Add($calabashRubyPath)
}

# Add GEM_HOME to the path
if (!($pathParts.Contains("${env:GEM_HOME}\bin")))
{
    $pathParts.Add("${env:GEM_HOME}\bin")
}

$newPath = [string]::Join(";", $pathParts)


[Environment]::SetEnvironmentVariable("Path", "${newPath}", "user")
[Environment]::SetEnvironmentVariable("Path", "${newPath}", "process")

$droidVersion = (calabash-android version) | Out-String
$iosVersion = (calabash-ios version) | Out-String
$testCloudVersion = (test-cloud version) | Out-String

Write-Host "Done! Installed:"
Write-Host "calabash-ios:       $iosVersion"
Write-Host "calabash-android:   $droidVersion"
Write-Host "xamarin-test-cloud: $testCloudVersion"
Write-host "Execute 'calabash-sandbox' to get started! "
Write-Host ""
