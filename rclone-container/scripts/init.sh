#!/usr/bin/expect -f

set timeout 20

spawn rclone config

expect "New remote"

send -- "n\r"

expect "name>"

send -- "assets\r"

expect "Storage>"

send -- "13\r"

expect "client_id>"

send -- "$env(CLIENT_ID)\r"

expect "client_secret>"

send -- "$env(CLIENT_SECRET)\r"

expect "scope>"

send -- "2\r"

expect "root_folder_id>"

send -- "/data\r"

expect "service_account_file>"

send -- "/config/.credentials.json\r"

expect "Edit advanced config? (y/n)"

send -- "n\r"

expect "Configure this as a team drive?"

send -- "n\r"

expect "Edit existing remote"

send -- "q\r"

expect "Yes this is OK (default)"

send -- "y\r"

expect eof
