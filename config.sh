#!/bin/bash

head=$( cat head.htm )
foot=$( cat foot.htm | sed "s/{BUILDDATE}/$( date )/" )

function backlink {
	backlinks="<br><hr /><h3>backlinks:</h3><ul>"
	for n in $( ls -tr src/*.htm ); do
		cat $n | grep -q "<a href=\"$1\""
		if test $? -eq 0; then
			back_name=$( echo "$n" | sed 's/src\///' | sed 's/\.htm//' )
			echo ". $back_name"
			backlinks+="<li><a href='$back_name.html'>$back_name</a></li>"
		fi
	done
	backlinks+="</ul>"
}

function index {
	echo "index"
	index="<h1>index</h1><ul>"
	for i in $( ls src/*.htm ); do
		name=$( echo "$i" | sed 's/src\///' | sed 's/\.htm//' )
		index+="<li><a href='$name.html'>$name</a></li>"
	done
	index+="</ul>"
	backlink index.html
	index_page="$head$index$backlinks$foot"
	echo "$index_page" > site/index.html
}

function pages {
	for i in $( ls -t src/*.htm ); do
		name=$( echo "$i" | sed 's/src\///' | sed 's/\.htm//' )
		echo "$name"
		main=$( cat $i )
		backlink $name.html
		page="$head$main$backlinks$foot"
		echo "$page" > site/$name.html
	done
}

function main {
	rm -r site && mkdir site
	pages
	index
}

time main
