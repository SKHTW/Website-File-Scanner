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
  "main.php~"   "accounts.txt~" "auth.txt~" "api.key~" "api_key.txt~"
  "token.txt~" "jwt.txt~" "session.txt~" "backup.sql~" "backup.tar~" "dump.sql~" "old.sql~" "old.php~" "test.php~"
  "dev.php~" "admin.php~" "login.php~" "register.php~" "upload.php~" "shell.php~"
  "info.php~" "config.inc.php~" "config.ini~" "config.yml~" "config.json~" "db.php~"
  "main.php~"
  ".git-credentials" ".npm-debug.log" ".yarn-integrity" ".babelrc" ".browserslistrc" ".codeclimate.yml"
  ".coveralls.yml" ".gitlab-ci.yml" ".htaccess.save" ".htpasswd.save" ".htgroup.save" ".htusers.save"
  ".htgroups.save" ".env.save" "config.php.save" "config.ini.save" "config.yml.save" "config.json.save"
  "db.php.save" "db.inc.php.save" "main.php.save" "index.php.bkp" "index.html.bkp" "error_log.bkp"
  "access_log.bkp" "debug.log.bkp" "trace.log.bkp" "dump.log.bkp" "secret.txt.bkp" "private.key.bkp"
  "public.key.bkp" "id_rsa.bkp" "id_dsa.bkp" "credentials.txt.bkp" "passwords.txt.bkp" "users.txt.bkp"
  "accounts.txt.bkp" "auth.txt.bkp" "api.key.bkp" "api_key.txt.bkp" "token.txt.bkp" "jwt.txt.bkp"
  "session.txt.bkp" "backup.sql.bkp" "backup.tar.bkp" "dump.sql.bkp" "old.sql.bkp" "old.php.bkp"
  "test.php.bkp" "dev.php.bkp" "admin.php.bkp" "login.php.bkp" "register.php.bkp" "upload.php.bkp"
  "shell.php.bkp" "info.php.bkp" "config.inc.php.bkp" "config.ini.bkp" "config.yml.bkp" "config.json.bkp"
  "db.php.bkp" "main.php.bkp" ".htacess.old" ".htpasswd.old" ".htgroup.old" ".htusers.old"
  ".htgroups.old" ".env.old" "config.php.old" "config.ini.old" "config.yml.old" "config.json.old"
  "db.php.old" "db.inc.php.old" "main.php.old" "index.php.orig" "index.html.orig" "error_log.orig"
  "access_log.orig" "debug.log.orig" "trace.log.orig" "dump.log.orig" "secret.txt.orig" "private.key.orig"
  "public.key.orig" "id_rsa.orig" "id_dsa.orig" "credentials.txt.orig" "passwords.txt.orig" "users.txt.orig"
  "accounts.txt.orig" "auth.txt.orig" "api.key.orig" "api_key.txt.orig" "token.txt.orig" "jwt.txt.orig"
  "session.txt.orig" "backup.sql.orig" "backup.tar.orig" "dump.sql.orig" "old.sql.orig" "old.php.orig"
  "test.php.orig" "dev.php.orig" "admin.php.orig" "login.php.orig" "register.php.orig" "upload.php.orig"
  "shell.php.orig" "info.php.orig" "config.inc.php.orig" "config.ini.orig" "config.yml.orig" "config.json.orig"
  "db.php.orig" "main.php.orig" ".htacess.swp" ".htpasswd.swp" ".htgroup.swp" ".htusers.swp"
  ".htgroups.swp" ".env.swp" "config.php.swp" "config.ini.swp" "config.yml.swp" "config.json.swp"
  "db.php.swp" "db.inc.php.swp" "main.php.swp" "index.php.swp" "index.html.swp" "error_log.swp"
  "access_log.swp" "debug.log.swp" "trace.log.swp" "dump.log.swp" "secret.txt.swp" "private.key.swp"
  "public.key.swp" "id_rsa.swp" "id_dsa.swp" "credentials.txt.swp" "passwords.txt.swp" "users.txt.swp"
  "accounts.txt.swp" "auth.txt.swp" "api.key.swp" "api_key.txt.swp" "token.txt.swp" "jwt.txt.swp"
  "session.txt.swp" "backup.sql.swp" "backup.tar.swp" "dump.sql.swp" "old.sql.swp" "old.php.swp"
  "test.php.swp" "dev.php.swp" "admin.php.swp" "login.php.swp" "register.php.swp" "upload.php.swp"
  "shell.php.swp" "info.php.swp" "config.inc.php.swp" "config.ini.swp" "config.yml.swp" "config.json.swp"
  "db.php.swp" "main.php.swp" ".htacess.bak~" ".htpasswd.bak~" ".htgroup.bak~" ".htusers.bak~"
  ".htgroups.bak~" ".env.bak~" "config.php.bak~" "config.ini.bak~" "config.yml.bak~" "config.json.bak~"
  "db.php.bak~" "db.inc.php.bak~" "main.php.bak~" "index.php.old~" "index.html.old~" "error_log.old~"
  "access_log.old~" "debug.log.old~" "trace.log.old~" "dump.log.old~" "secret.txt.old~" "private.key.old~"
  "public.key.old~" "id_rsa.old~" "id_dsa.old~" "credentials.txt.old~" "passwords.txt.old~" "users.txt.old~"
  "accounts.txt.old~" "auth.txt.old~" "api.key.old~" "api_key.txt.old~" "token.txt.old~" "jwt.txt.old~"
  "session.txt.old~" "backup.sql.old~" "backup.tar.old~" "dump.sql.old~" "old.sql.old~" "old.php.old~"
  "test.php.old~" "dev.php.old~" "admin.php.old~" "login.php.old~" "register.php.old~" "upload.php.old~"
  "shell.php.old~" "info.php.old~" "config.inc.php.old~" "config.ini.old~" "config.yml.old~" "config.json.old~"
  "db.php.old~" "main.php.old~" "index.php.orig~" "index.html.orig~" "error_log.orig~" "access_log.orig~"
  "debug.log.orig~" "trace.log.orig~" "dump.log.orig~" "secret.txt.orig~" "private.key.orig~" "public.key.orig~"
  "id_rsa.orig~" "id_dsa.orig~" "credentials.txt.orig~" "passwords.txt.orig~" "users.txt.orig~"
  "accounts.txt.orig~" "auth.txt.orig~" "api.key.orig~" "api_key.txt.orig~" "token.txt.orig~" "jwt.txt.orig~"
  "session.txt.orig~" "backup.sql.orig~" "backup.tar.orig~" "dump.sql.orig~" "old.sql.orig~" "old.php.orig~"
  "test.php.orig~" "dev.php.orig~" "admin.php.orig~" "login.php.orig~" "register.php.orig~" "upload.php.orig~"
  "shell.php.orig~" "info.php.orig~" "config.inc.php.orig~" "config.ini.orig~" "config.yml.orig~" "config.json.orig~"
  "db.php.orig~" "main.php.orig~" ".htacess.swp~" ".htpasswd.swp~" ".htgroup.swp~" ".htusers.swp~"
  ".htgroups.swp~" ".env.swp~" "config.php.swp~" "config.ini.swp~" "config.yml.swp~" "config.json.swp~"
  "db.php.swp~" "db.inc.php.swp~" "main.php.swp~" "index.php.swp~" "index.html.swp~" "error_log.swp~"
  "access_log.swp~" "debug.log.swp~" "trace.log.swp~" "dump.log.swp~" "secret.txt.swp~" "private.key.swp~"
  "public.key.swp~" "id_rsa.swp~" "id_dsa.swp~" "credentials.txt.swp~" "passwords.txt.swp~" "users.txt.swp~"
  "accounts.txt.swp~" "auth.txt.swp~" "api.key.swp~" "api_key.txt.swp~" "token.txt.swp~" "jwt.txt.swp~"
  "session.txt.swp~" "backup.sql.swp~" "backup.tar.swp~" "dump.sql.swp~" "old.sql.swp~" "old.php.swp~"
  "test.php.swp~" "dev.php.swp~" "admin.php.swp~" "login.php.swp~" "register.php.swp~" "upload.php.swp~"
  "shell.php.swp~" "info.php.swp~" "config.inc.php.swp~" "config.ini.swp~" "config.yml.swp~" "config.json.swp~"
  "db.php.swp~" "main.php.swp"
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
