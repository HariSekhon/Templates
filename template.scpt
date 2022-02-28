#!/usr/bin/env osascript
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: [% DATE  # 2020-06-13 20:47:12 +0100 (Sat, 13 Jun 2020) %]
#
#  [% URL  # https://github.com/HariSekhon/Templates %]
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/HariSekhon
#

# ============================================================================ #
#                             A p p l e S c r i p t
# ============================================================================ #

set folderName to "My New Folder"
set folderLocation to desktop

tell application "Finder"
    make new folder with properties {name:folderName, location:folderLocation}
end tell


set x to 2555
set y to 1255

tell application "System Events"
    click at {x,y}
end tell

tell application "Google Chome" to keystroke "w" using command down
