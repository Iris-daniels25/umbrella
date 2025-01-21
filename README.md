# Umbrella Weather App

**Description**

The Umbrella Weather App is a simple command-line Ruby application that checks the weather at a given location and determines if you might need an umbrella. It fetches latitude and longitude from Google Maps and then retrieves real-time weather data from Pirate Weather API to display the temperature, next-hour forecast, and precipitation chances.

**Installation Instructions**

1. Clone the Repository

If you haven't already, clone this repository:

git clone https://github.com/your-username/umbrella-weather.git
cd umbrella-weather

2. Install Required Dependencies

Ensure you have Ruby installed, then install the required gems:

gem install http dotenv json

3. Set Up API Keys

This application requires two API keys:

Google Maps API Key (to get latitude & longitude from a location)

Pirate Weather API Key (to get weather data)

Create a .env file in the project directory:

touch .env

Then open it and add your API keys:

GMAPS_KEY=your_google_maps_api_key
PIRATE_WEATHER_KEY=your_pirate_weather_api_key

Save the file.

Usage Instructions

Run the script using:

ruby umbrella.rb

The program will prompt you to enter a location. After inputting a city or address, it will:
✅ Fetch the latitude and longitude from Google Maps API✅ Retrieve the current temperature and weather summary from Pirate Weather API✅ Display the chances of rain in the next 12 hours✅ Suggest whether you need an umbrella

**Example Output**

========================================
   Will you need an umbrella today?     
========================================

Where are you?  
Chicago, IL  
Checking the weather at Chicago, IL....  
Your coordinates are 41.8781, -87.6298.  
It is currently 65°F.  
Next hour: Light rain starting soon.  
In 2 hours, there is a 40% chance of precipitation.  
In 5 hours, there is a 60% chance of precipitation.  
You might want to take an umbrella!  

**Troubleshooting**

--Common Issues & Fixes

--Missing API Key Error

Ensure .env is correctly formatted and contains valid API keys.

Try running:

echo $GMAPS_KEY
echo $PIRATE_WEATHER_KEY

to verify they are loaded correctly.

--Invalid Location

If you get an error saying "Unable to find location coordinates", try entering a more specific address.

--No Weather Data Available

Pirate Weather API may not have coverage for some locations. Try another city.

--Future Enhancements

Allow users to check the forecast for multiple locations.

Display additional weather details like wind speed and humidity.

Add support for international units (Celsius, mm of rain, etc.).

Implement a web or mobile version.

License

This project is open-source and available under the MIT License.

