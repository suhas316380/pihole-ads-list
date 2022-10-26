#!/bin/bash

# set working dir to script dir
cd "$(dirname "$0")"

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
  #curl -s ${URL} -o ${file_name} && cat ${file_name} >> blocked.list
done

# Remove lines starting with "#"
sed -i '/^#/ d' blocked.list

# Remove 127.0.0.1, 0.0.0.0, ::, ^ at the end of lines, || at the beginning, ^M and leading white spaces
sed -i -e 's/^127.0.0.1//' -e 's/^0.0.0.0//' -e '/::/d' -e 's/\^//' -e 's/^||//' -e 's/\r//g' -e "s/^[ \t]*//" blocked.list

# Remove duplicate lines
perl -i -ne 'print if ! $a{$_}++' blocked.list

# move youtube domains to a file - removing this as youtube ads are unblocked for now
# sed -nr '/googlevideo.com/p' blocked.list > youtube.list
sed -i '/googlevideo.com/d' blocked.list
