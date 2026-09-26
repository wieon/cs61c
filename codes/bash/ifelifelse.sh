#!/bin/bash

if [ ${1,,} = Amy ]; then  
	echo "Hi!"
elif [ ${1,,} = help ]; then
	echo "SOS"
else
	echo "Wait a moment."
fi
