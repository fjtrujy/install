Write-Host 'Installing Calabash on Windows:'

# STEP 1: Check the version of Ruby installed.
$result = & "ruby" "-v"
Write-Host "  Ruby version installed: " $result

# STEP 2: Create the Calabash directory if necessary.
$calabashDir = "$env:USERPROFILE\calabash\"
if (Test-Path $calabashDir)
{
	Write-Host "  The directory $calabashDir already exists - aborting install."
}
else 
{
	New-Item $calabashDir -ItemType directory | Out-Null
	Write-Host "  Creating the Calabash directory at $calabashDir"	

# Not sure we need/should do this on Windows.	
#	[Environment]::SetEnvironmentVariable("GEM_HOME", $calabashDir, "user")
#	[Environment]::SetEnvironmentVariable("GEM_PATH", $calabashDir, "user")
#	Write-Host "  Setting GEM_HOME and GEM_PATH to $calabashDir."


	# STEP 3: Download the SSL Certificate and set the SSL_CERT_FILE 
	# environment variable for the process.
	$cacertFile = "$calabashDir\cacert.pem"
	Invoke-WebRequest 'http://curl.haxx.se/ca/cacert.pem' -OutFile $cacertFile
	[Environment]::SetEnvironmentVariable("SSL_CERT_FILE", $cacertFile, "Process")

	# STEP 4: Install the gem
	Write-Host "  Installing xamarin-test-cloud..."
	& "gem" "install" "xamarin-test-cloud" "--platform=ruby"  "--no-ri" "--no-rdoc"
	Write-Host " "
	Write-Host $installXTC

	Write-Host "  Installing calabash-android..."
	& "gem" "install" "calabash-android" "--platform=ruby"  "--no-ri" "--no-rdoc"
	Write-Host " "
	Write-Host $installCalabashAndroid
}


