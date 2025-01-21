require "http"
require "json"
require "dotenv/load"

line_width = 40

puts "*" * line_width
puts "Will you need an umbrella today?".center(line_width)
puts "*" * line_width
puts
puts "Where are you?"
user_location = gets.chomp

puts "Checking the weather at #{user_location}...."

# Get the lat/lng of location from Google Maps API
gmaps_key = ENV.fetch("GMAPS_KEY", "MISSING_KEY")

if gmaps_key == "MISSING_KEY"
  puts "Error: Google Maps API key is missing. Check your .env file."
  exit
end

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}"
raw_gmaps_data = HTTP.get(gmaps_url)

begin
  parsed_gmaps_data = JSON.parse(raw_gmaps_data.body.to_s)
rescue JSON::ParserError => e
  puts "Error parsing Google Maps response: #{e.message}"
  exit
end

results_array = parsed_gmaps_data.fetch("results", [])

if results_array.empty?
  puts "Error: Unable to find location coordinates for '#{user_location}'."
  exit
end

first_result_hash = results_array.at(0)
geometry_hash = first_result_hash.fetch("geometry", {})
location_hash = geometry_hash.fetch("location", {})

latitude = location_hash.fetch("lat", nil)
longitude = location_hash.fetch("lng", nil)

if latitude.nil? || longitude.nil?
  puts "Error: Could not retrieve latitude/longitude."
  exit
end

puts "Your coordinates are #{latitude}, #{longitude}."

# Get the weather from Pirate Weather API
pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY", "MISSING_KEY")

if pirate_weather_key == "MISSING_KEY"
  puts "Error: Pirate Weather API key is missing. Check your .env file."
  exit
end

pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{latitude},#{longitude}"
raw_pirate_weather_data = HTTP.get(pirate_weather_url)

begin
  parsed_pirate_weather_data = JSON.parse(raw_pirate_weather_data.body.to_s)
rescue JSON::ParserError => e
  puts "Error parsing Pirate Weather response: #{e.message}"
  exit
end

currently_hash = parsed_pirate_weather_data.dig("currently")

if currently_hash.nil?
  puts "Error: Could not fetch current weather data."
  exit
end

current_temp = currently_hash.fetch("temperature", "N/A")
puts "It is currently #{current_temp}°F."

# Some locations around the world do not come with minutely data.
minutely_hash = parsed_pirate_weather_data.dig("minutely")

if minutely_hash
  next_hour_summary = minutely_hash.fetch("summary", "No summary available.")
  puts "Next hour: #{next_hour_summary}"
end

hourly_data_array = parsed_pirate_weather_data.dig("hourly", "data")

if hourly_data_array.nil?
  puts "Error: No hourly weather data available."
  exit
end

next_twelve_hours = hourly_data_array[1..12]
precip_prob_threshold = 0.10
any_precipitation = false

next_twelve_hours.each do |hour_hash|
  precip_prob = hour_hash.fetch("precipProbability", 0.0)

  if precip_prob > precip_prob_threshold
    any_precipitation = true
    precip_time = Time.at(hour_hash.fetch("time"))
    hours_from_now = ((precip_time - Time.now) / 60 / 60).round
    puts "In #{hours_from_now} hours, there is a #{(precip_prob * 100).round}% chance of precipitation."
  end
end

if any_precipitation
  puts "You might want to take an umbrella!"
else
  puts "You probably won't need an umbrella."
end
