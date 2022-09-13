jq -r '.Users[] |.Username | "Username: "+ . +"" ' users.txt

jq -r '.Users[]| select(.Username=="valerio.cammarota@eng.it") |.Attributes[]' users.txt

 jq -r '.Users[].Attributes[] | select((.Name =="email") and (^Calue=="valerio.cammarota@eng.it")) ' users.txt | more

 jq -r '.Users[] | keys[] as $k | "\($k)  \(.[$k] )"' users.txt