DIR=$1
COMMAND=$2

$COMMAND

inotifywait -q -e close_write,moved_to,create -m $DIR |
while read -r directory events filename; do
	echo $directory
	echo $events
	echo $filename
	clear
	$COMMAND
done

