#!/bin/bash

# Function to check if a file exists on the website
check_file() {
  url="$1"
  file="$2"
  status_code=$(curl -s -o /dev/null -w "%{http_code}" "${url}${file}")

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
files_to_search=(
  "robots.txt" "sitemap.xml" ".DS_Store" ".htaccess" ".htpasswd" ".git" ".svn"
  "wp-config.php" "wp-admin" "wp-includes" "wp-content" "readme.html" "xmlrpc.php"
  ".env" "config.php" "phpinfo.php" ".idea" ".dockerignore" "Dockerfile"
  ".editorconfig" ".eslintignore" ".eslintrc" ".gitattributes" ".gitignore"
  ".gitmodules" ".hgignore" ".hgtags" ".npmignore" ".npmrc" ".nvmrc"
  ".prettierignore" ".prettierrc" ".styleci.yml" ".stylelintignore" ".stylelintrc"
  ".travis.yml" ".yarnrc" "package.json" "package-lock.json" "yarn.lock"
  "composer.json" "composer.lock" "server-status"
  "backup.zip" "backup.tar.gz" "backup.sql" "database.sql" "database.dump"
  "old.zip" "old.tar.gz" "old.php" "test.php" "dev.php"
  "admin.php" "login.php" "register.php" "upload.php" "shell.php"
  "info.php" "config.inc.php" "config.ini" "config.yml" "config.json"
  "db.php" "db.inc.php" "main.php" "index.php.bak" "index.html.bak"
  "error_log" "access_log" "debug.log" "trace.log" "dump.log"
  "secret.txt" "private.key" "public.key" "id_rsa" "id_dsa"
  "credentials.txt" "passwords.txt" "users.txt" "accounts.txt" "auth.txt"
  "api.key" "api_key.txt" "token.txt" "jwt.txt" "session.txt"
  "backup.sql.gz" "backup.tar.bz2" "backup.7z" "dump.sql.gz" "dump.tar.gz"
  "old.sql" "old.php.bak" "test.html" "dev.html" "admin.html"
  "login.html" "register.html" "upload.html" "shell.html.bak" "info.html"
  "config.php.bak" "config.ini.bak" "config.yml.bak" "config.json.bak" "db.php.bak"
  "main.html" "index.php.old" "index.html.old" "error_log.old" "access_log.old"
  "debug.log.old" "trace.log.old" "dump.log.old" "secret.txt.old" "private.key.old"
  "public.key.old" "id_rsa.old" "id_dsa.old" "credentials.txt.old" "passwords.txt.old"
  "users.txt.old" "accounts.txt.old" "auth.txt.old" "api.key.old" "api_key.txt.old"
  "token.txt.old" "jwt.txt.old" "session.txt.old" "backup.sql.old" "backup.tar.old"
  "dump.sql.old" "old.sql.old" "old.php.old" "test.php.old" "dev.php.old"
  "admin.php.old" "login.php.old" "register.php.old" "upload.php.old" "shell.php.old"
  "info.php.old" "config.inc.php.old" "config.ini.old" "config.yml.old" "config.json.old"
  "db.php.old" "main.php.old" "index.php~" "index.html~" "error_log~" "access_log~"
  "debug.log~" "trace.log~" "dump.log~" "secret.txt~" "private.key~" "public.key~"
  "id_rsa~" "id_dsa~" "credentials.txt~" "passwords.txt~" "users.txt~" "accounts.txt~"
  "auth.txt~" "api.key~" "api_key.txt~" "token.txt~" "jwt.txt~" "session.txt~"
  "backup.sql~" "backup.tar~" "dump.sql~" "old.sql~" "old.php~" "test.php~"
  "dev.php~" "admin.php~" "login.php~" "register.php~" "upload.php~" "shell.php~"
  "info.php~" "config.inc.php~" "config.ini~" "config.yml~" "config.json~" "db.php~"
  "main.php~"
)

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
