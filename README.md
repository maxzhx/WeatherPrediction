# ProjectThree

## About

SWEN30006 Project three

## Authors

Huixiang Zheng - 666889

Dongliang Liu - 701811

Kun Qin - 674258

Xue Jiang - 665401

## Code files

### Scheduler
/config/initializers/scheduler.rb

### Tasks
/lib/tasks/weather.rake

## API:

### Weather (http://openweathermap.org/weather-data#current)
http://api.openweathermap.org/data/2.5/weather?lat=-37&lon=144&units=metric

### Lat and Long to Postcode
http://maps.googleapis.com/maps/api/geocode/json?latlng=-37,144&sensor=true

### Postcode to Lat and Long
http://v0.postcodeapi.com.au/suburbs/3463.json

## Testing

### getLocation
rake weather:getLocation

### getForecast
rake weather:getForcast
