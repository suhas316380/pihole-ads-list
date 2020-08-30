#!/bin/sh

rm -f blocked.list

# Read URLs from list.list
for URL in `cat list.list`; do 
  
  # Get the last part of the URL - filename
  file_name=${URL##*/}
  [[ -z "${file_name// }" ]] && file_name=${RANDOM:0:99}

  # Check if filename has ".txt" ext; if not, add it
  if grep -q ".txt" <<< "$file_name"; then
    :
  else
    file_name="${file_name}.txt"
  fi

  # Check if there is a file already with that name. If yes, append a random number to the file_name
  if [ -e "${file_name}" ]; then
    random_num=${RANDOM:0:99}
    file_name="${file_name//.txt/}-${random_num}.txt"
  fi

  # Download the file
  echo ${URL}  ${file_name}
  curl -s ${URL} -o ${file_name} && cat ${file_name} >> blocked.list && rm -f ${file_name}
done

# Remove duplicate lines
perl -i -ne 'print if ! $a{$_}++' blocked.list

