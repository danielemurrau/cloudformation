jq -r '.Users[] |.Username | "Username: "+ . +"" ' users.txt

jq -r '.Users[]| select(.Username=="name.surname@xxxxx.it") |.Attributes[]' users.txt

 jq -r '.Users[].Attributes[] | select((.Name =="email") and (^Calue=="name.surname@xxxx.it")) ' users.txt | more

 jq -r '.Users[] | keys[] as $k | "\($k)  \(.[$k] )"' users.txt