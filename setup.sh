#!/usr/bin/env bash

###################
# DEFINITIONS
###################

service='Xcode'
plugins_dir=~/Library/Developer/Xcode/Plug-ins/

###################
# SHUT DOWN XCODE IF IT'S RUNNING
###################

if pgrep -xq -- "${service}"; then
  echo "Xcode is running. Attempt to shut down? y/n"
  read answer
  if [ "$answer" = "y" ]; then
    echo "Shutting down Xcode"
    pkill -x $service
  else
    echo "Xcode needs to be closed"
    exit 1
  fi
fi

###################

if [ -d "${plugins_dir}Kotlin.ideplugin/" ]; then
	echo "Plugins directory and Kotlin plugin found. Deleting..."
  rm -rf $plugins_dir
  open -a $service
  pkill -x $service
fi

echo "Creating plugins directory"
mkdir -p $plugins_dir
cp -r Kotlin.ideplugin $plugins_dir

###################
# LLDB DEFINITIONS
###################

lldb_config="command script import ~/Library/Developer/Xcode/Plug-ins/Kotlin.ideplugin/Contents/Resources/konan_lldb_config.py"
lldb_format="command script import ~/Library/Developer/Xcode/Plug-ins/Kotlin.ideplugin/Contents/Resources/konan_lldb.py"

if grep --quiet	-s konan_lldb ~/.lldbinit-Xcode
then
    # code if found
		echo "konan_lldb.py found in ~/.lldbinit-Xcode"
else
    # code if not found
		echo $lldb_config >> ~/.lldbinit-Xcode
		echo $lldb_format >> ~/.lldbinit-Xcode
fi

