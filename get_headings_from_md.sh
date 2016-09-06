#!/bin/bash -ex

if [ -s "$1" ]; then
	if [ "$1" = "-h" ]; then
		echo "Usage: $0 [ output_file_name ]"
		echo "Recursively finds all Markdown files (.md) in the current directory"
		echo "and captures their headings into a tab-delimited CSV (defaults to ./headings.txt)."
		echo "The CSV has three columns: file_name, heading_sequence, heading"
		echo "You can import this CSV into your favorite spreadsheet program."
	else
		OUTFILE="$1"
	fi
fi

# If $OUTFILE is not yet set
if [ -z "$OUTFILE" ]; then
	OUTFILE='headings.txt'
fi

# Move existing file out of the way
if [ -f "$OUTFILE" ]; then
	mv "$OUTFILE" "${OUTFILE}.bk"
	echo "Moved existing file $OUTFILE to ${OUTFILE}.bk."
fi

# Start the CSV file with the headings
echo -e "file_name\theading_sequence\theading" > "$OUTFILE"

find . -type f -name "*.md"| while read -r i; do
  COUNT=0
  grep -E '^#+\s+.+$' "$i"|while read -r j; do
  	let COUNT=COUNT+1
    echo -e "$i\t$COUNT\t$j" >> headings.txt
  done

done

echo "All done. You can import the tab-delimited CSV file ${OUTFILE} into your"
echo "favorite spreadsheet program to view the report."