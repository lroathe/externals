#run as source in bash
function num_lines() {
  echo "$@" | wc -l
}

file=.externals
cpath=$(pwd)
while [ ! -f "$cpath/$file" ] && [ "x$cpath" != 'x/' ]; do
	cpath=$(dirname "$cpath")
done
if [ ! -f "$cpath/$file" ]; then
	echo "Are you sure your in a repo?  Didn't find $file file"
else
	base_path=$cpath
	list=$(grep path "$cpath/$file" | sed 's/^path = //')
	if [ "x$1" == "x" ]; then
		echo "$list"
	elif [ "x$1" == 'x.' ]; then
		cd "$cpath"
	else
		subproject=$(echo "$list" | grep "$1" | tr -d '\r')
                if [ $(num_lines "$subproject") -gt 1 ]; then
			subproject=$(echo "$subproject" | egrep "$1$" | tr -d '\r')
                fi
                lines=$(num_lines "$subproject")

		if [ $lines -eq 1 ]; then
			cd $cpath
			cd ./$subproject
			cd $cpath/$subproject
		elif [ $lines -eq 0 ]; then
			echo "No project matched given string"
		else
			echo "Project string was not unique"
		fi
	fi
fi
