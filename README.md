Website File Scanner

This is a simple Bash script that scans a given website for the presence of specific files and directories that may expose sensitive information or reveal the site's underlying technologies. The script makes HTTP requests to check if the specified files exist and outputs the results.

Features

Scans for a wide range of files and directories that may expose sensitive information
Saves the list of found files to a text file for easy reference
Provides an interactive command-line interface

Files and Directories Scanned
This script scans for the following files and directories:

robots.txt
sitemap.xml 
.DS_Store
.htaccess
.htpasswd
.git
.svn
wp-config.php
wp-admin
wp-includes
wp-content
readme.html
xmlrpc.php
.env
config.php
phpinfo.php
.idea
.dockerignore
Dockerfile
.editorconfig
.eslintignore
.eslintrc
.gitattributes
.gitignore
.gitmodules
.hgignore
.hgtags
.npmignore
.npmrc
.nvmrc
.prettierignore
.prettierrc
.styleci.yml
.stylelintignore
.stylelintrc
.travis.yml
.yarnrc
package.json
package-lock.json
yarn.lock
composer.json
composer.lock
server-status

Prerequisites

This script requires curl to be installed on your system. Most Unix-based systems come with curl pre-installed. If not, you can install it using the package manager for your operating system.

Usage

Save the script as file-sniff.sh in a directory of your choice.

Make the script executable with the following command:

chmod +x file-sniff.sh

Run the script using:

./file-sniff.sh

Enter the target website URL when prompted, and the script will begin scanning for the specified files and directories.

If any files are found, their URLs will be displayed in the terminal and saved in a text file named found_files.txt in the same directory as the script.

If no specified files are found, the script will display a message to inform you.


Adding More Files to Search For


If you want to extend the list of files and directories the script scans for, follow these steps:

Open the find_files.sh script in a text editor.
Locate the files_to_search array within the script.
Add new filenames or directory names as elements in the array, separated by spaces, like this:

files_to_search=("existing_file1" "existing_file2" "new_file1" "new_directory1")

Save the changes and run the script as usual. The newly added files and directories will be included in the scan.


Customization

To add or remove files and directories from the list of items to scan, simply modify the files_to_search array in the script. Add or remove the desired filenames or directory names as needed.
