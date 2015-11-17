Param([switch]$ReplaceCalabashUserFiles)

Function Remove-Directory([string]$DirectoryToRemove)
{
    if (Test-Path $DirectoryToRemove)
    {
        if (!($ReplaceCalabashUserFiles))
        {
            do {
                $deleteDir = Read-Host "The directory $DirectoryToRemove already exists.  Do you want to delete it? (Y | N)"
                if ($deleteDir -eq "N")
                {
                    Write-Host "  Unable to continue, exiting."
                    Return $False
                }
            
            } while ($deleteDir -notmatch "[Y]")
        }

        Remove-Item -Recurse -Force $DirectoryToRemove
    }

    Return $True
}

Write-Host ' '
Write-Host 'Installing Calabash on Windows:'
Write-Host " "

# STEP 1: Check the version of Ruby installed.
$result = & "ruby" "-v"
Write-Host "  Ruby version installed: " $result
Write-Host "  "

# STEP 2: Perform a quick check to see if the Android SDK is installed
$androidHome = "$env:ANDROID_HOME"
if ([String]::IsNullOrWhiteSpace($androidHome)) 
{
	Write-Host "  Could not not detect the Android SDK. Please ensure that it is installed"
	Write-Host "  and that the ANDROID_HOME environment variable is set."
}
else 
{
	Write-Host "  Detected the Android SDK at $androidHome."
}
Write-Host "  "

# STEP 3: Create the Calabash directory if required.
$calabashDir = "$env:USERPROFILE\calabash"
if (!(Test-Path $calabashDir)) 
{
	Write-Host "  Creating the Calabash directory at $calabashDir."	
	New-Item $calabashDir -ItemType directory | Out-Null
	Write-Host " "
}

# STEP 4: Removing any existing Certificates directory.
$cacertDir = "$calabashDir\certs"
if (!(Remove-Directory -DirectoryToRemove $cacertDir))
{
    Exit
}

# STEP 5: Create a new Certificates directory.
Write-Host "  Creating the Calabash cert directory at $cacertDir."	
New-Item $cacertDir -ItemType directory | Out-Null
Write-Host " "

# STEP 6: Download the SSL Certificate and set the SSL_CERT_FILE 
# environment variable for the process.
$cacertFile = "$cacertDir\cacert.pem"
Write-Host "  Downloading SSL certificate to $cacertFile."
Invoke-WebRequest 'http://curl.haxx.se/ca/cacert.pem' -OutFile $cacertFile
Write-Host " "

Write-Host "  Set the environment variable SSL_CERT_FILE=$cacertFile."
[Environment]::SetEnvironmentVariable("SSL_CERT_FILE", $cacertFile, "user")
[Environment]::SetEnvironmentVariable("SSL_CERT_FILE", $cacertFile, "process")
Write-Host " "

# STEP 7: Remove any existing Gems directory.
$gemsDir = "$calabashDir\gems"
if (!(Remove-Directory -DirectoryToRemove $gemsDir))
{
    Exit
}

# STEP 8: Create the Gems directory.
Write-Host "  Creating the Calabash gems directory at $gemsDir."
New-Item $gemsDir -ItemType directory | Out-Null
Write-Host " "

# STEP 9: Update the version of RubyGems 
Write-Host "  Performing a system update of RubyGems:"
& "gem" "update" "--system"
Write-Host " "

# STEP 10: set the GEN_HOME and GEN_PATH environment variables.
$Env:GEM_HOME = $gemsDir;
$Env:GEM_PATH = $gemsDir;

# STEP 11: Install the gems
Write-Host "    Installing xamarin-test-cloud..."
& "gem" "install" "xamarin-test-cloud" "--platform=ruby"  "--no-document"
Write-Host " "

Write-Host "    Installing calabash-android..."
& "gem" "install" "calabash-android" "--platform=ruby"  "--no-document"
Write-Host " "

Write-Host "Finished installing Calabash on Windows."
