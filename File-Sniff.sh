#!/bin/bash

# Function to check if a file exists on the website
check_file() {
  url="$1"
  file="$2"
  status_code=$(curl -o /dev/null -s -w "%{http_code}" "${url}${file}")

  if [ "$status_code" -eq "200" ]; then
    echo "Found: ${url}${file}"
    echo "${url}${file}" >> "$output_file"
    found_files=1
  fi
}

# Validate and set the target URL
read -p "Enter the target website URL: " target_url
if [[ ! "$target_url" =~ ^https?:// ]]; then
  echo "Invalid URL. Please include http:// or https://"
  exit 1
fi

# Ensure the URL ends with a slash
target_url="${target_url%/}/"

# Allow user to specify output file or use default
read -p "Enter output file name (default: found_files.txt): " output_file
output_file=${output_file:-found_files.txt}

# Expanded list of files and directories to search for
files_to_search=("robots.txt" "sitemap.xml" ... "server-status")

# Check for each file on the website
found_files=0
echo "Searching for files in $target_url..."
rm -f "$output_file"  # Clear previous results

for file in "${files_to_search[@]}"; do
  check_file "$target_url" "$file"
done

# Display a message based on the search result
if [ "$found_files" -eq "0" ]; then
  echo "No specified files were found."
else
  echo "Results have been saved in $output_file"
fi
