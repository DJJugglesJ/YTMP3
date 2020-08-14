# YTMP3 written by Nick Gartin.
# Script is free to use for anyone who wants.
# You may not repackage and sell, it must remain free.
# Enjoy!

    #Check for Youtube Downloader plugin
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' youtube-dl|grep "install ok installed")
echo Checking for youtube-dl: $PKG_OK
if [ "" == "$PKG_OK" ]; then
  echo "No youtube-dl. Setting up youtube-dl."
  sudo apt-get --force-yes --yes install youtube-dl
fi

    #Check for ffmpeg
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' ffmpeg|grep "install ok installed")
echo Checking for ffmpeg: $PKG_OK
if [ "" == "$PKG_OK" ]; then
  echo "No ffmpeg. Setting up ffmpeg."
  sudo apt-get --force-yes --yes install ffmpeg
fi

    #Check for X Clipboard manager
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' xclip|grep "install ok installed")
echo Checking for xclip: $PKG_OK
if [ "" == "$PKG_OK" ]; then
  echo "No xclip. Setting up xclip."
  sudo apt-get --force-yes --yes install xclip
fi
    
    
    echo Make sure you have copied the link to the video you wish to download.
    read -p "Press [Enter] key to continue"
    url="$(xclip -o)"
    com='youtube-dl -x --audio-format mp3'
    str=$com' '$url
    $str
