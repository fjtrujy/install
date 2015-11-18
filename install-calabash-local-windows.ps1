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
$calabashDir = "$env:USERPROFILE\.calabash"
if (!(Test-Path $calabashDir)) 
{
	Write-Host "  Creating the Calabash directory at $calabashDir."	
	New-Item $calabashDir -ItemType directory | Out-Null
	Write-Host " "
}

# STEP 4: Get the SSL certificates directory
$rubygems = iex "gem which rubygems"
if (!($rubygems.EndsWith("rubygems.rb")))
{
    Write-Host " "
    Write-Host "  Unable to locate rubygems install directory!  Exiting..."
    Write-Host " "
    Exit
}
$rubygemsDir = $rubygems.Substring(0, $rubygems.Length - 3)
$sslCertsDir = "$rubygemsDir\ssl_certs"

# STEP 5: Download the SSL Certificate if required.
$cacertFile = "$sslCertsDir\AddTrustExternalCARoot.pem"
if (!(Test-Path $cacertFile))
{
    Write-Host "  Downloading SSL certificate to $cacertFile."
    Invoke-WebRequest 'https://github.com/rubygems/rubygems/raw/master/lib/rubygems/ssl_certs/AddTrustExternalCARoot.pem' -OutFile $cacertFile
    Write-Host " "
}

# STEP 6: Update the version of RubyGems 
Write-Host "  Performing a system update of RubyGems:"
& "gem" "update" "--system"
Write-Host " "

# STEP 7: Install the gems
Write-Host "  Installing Calabash... This could take a few minutes"
Write-Host " "

Write-Host "    Installing xamarin-test-cloud..."
& "gem" "install" "xamarin-test-cloud" "--platform=ruby"  "--no-document"
Write-Host " "

Write-Host "    Installing calabash-android..."
& "gem" "install" "calabash-android" "--platform=ruby"  "--no-document"
Write-Host " "

Write-Host "Done Installing!"
Write-Host " "
Write-Host "You can always uninstall using:"
Write-Host " "
Write-Host "  gem uninstall xamarin-test-cloud"
Write-Host "  gem uninstall calabash-android"

