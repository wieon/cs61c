case ${1,,} in
	herbert | admin)
		echo "Welcome!"
		;;
	help)
		echo "SOS"
		;;
	*)
		echo "Quiet!"
		;;

esac
