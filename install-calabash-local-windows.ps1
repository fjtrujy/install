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
	Write-Host "  "
	Write-Host "  Detected the Android SDK at $androidHome."
}
Write-Host "  "

$calabashDir = "$env:USERPROFILE\calabash\"
if (Test-Path $calabashDir)
{
	Write-Host " "
	Write-Host "The directory $calabashDir already exists - aborting install."
	Write-Host "If you want to run this script again, please delete that directory."
	Write-Host " "
}
else 
{
	# STEP 3: Create the Calabash directory.
	Write-Host "  Creating the Calabash directory at $calabashDir."	
	New-Item $calabashDir -ItemType directory | Out-Null
	Write-Host " "

	# STEP 4: Download the SSL Certificate and set the SSL_CERT_FILE 
	# environment variable for the process.
	$cacertFile = "$calabashDir\cacert.pem"
	Write-Host "  Downloading SSL certificate to $cacertFile."
	Invoke-WebRequest 'http://curl.haxx.se/ca/cacert.pem' -OutFile $cacertFile
	Write-Host " "

	Write-Host "  Set the environment variable SSL_CERT_FILE=$cacertFile."
	[Environment]::SetEnvironmentVariable("SSL_CERT_FILE", $cacertFile, "user")
	[Environment]::SetEnvironmentVariable("SSL_CERT_FILE", $cacertFile, "process")
	Write-Host " "

	# STEP 5: Update the version of RubyGems 
	Write-Host "  Performing a system update of RubyGems:"
	& "gem" "update" "--system"
	Write-Host " "

	# STEP 6: Install the gems
	Write-Host "    Installing ffi..."
	& "gem" "install" "ffi" "--platform=ruby" "--no-ri" "--no-rdoc"
	Write-Host " "
	
	Write-Host "    Installing xamarin-test-cloud..."
	& "gem" "install" "xamarin-test-cloud" "--platform=ruby"  "--no-ri" "--no-rdoc"
	Write-Host " "

	Write-Host "    Installing calabash-android..."
	& "gem" "install" "calabash-android" "--platform=ruby"  "--no-ri" "--no-rdoc"
	Write-Host " "

	Write-Host "Finished installing Calabash on Windows."
}
