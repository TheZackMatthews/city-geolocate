# city-geolocate.bash, by Zack Matthews
# Attempts to fetch location from IP address, then exchange it for an openWeather cityId

# ipstack.com API Key (1000 requests / month)
# openweather.com API Key (1000 requests / day)
source ./.env

OUTPUT_FILE=cityId.txt

PUBLIC_IP=`curl -s https://ipinfo.io/ip`
echo "Public IP: ${PUBLIC_IP}"

# Call the geolocation API and capture the output and save the JSON output
RESPONSE=`curl -s http://api.ipstack.com/${PUBLIC_IP}?access_key=${IPSTACK_API_KEY} | jq 'del(.location.is_eu)'`
echo "Geolocation API Response: ${RESPONSE}"

PROCESSED_RESPONSE=$(echo ${RESPONSE} | jq 'walk(if type == "object" then with_entries(select(.value != null)) else . end)')
echo "Processed Response: ${PROCESSED_RESPONSE}"


echo -n "" > ~/.config/qtile/current_location.py

echo data=${PROCESSED_RESPONSE} >> ~/.config/qtile/current_location.py
echo -n "" > ${OUTPUT_FILE}

cat ${OUTPUT_FILE}
