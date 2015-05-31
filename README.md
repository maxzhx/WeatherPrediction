# ProjectThree

## About

SWEN30006 Project three

## Authors

Huixiang Zheng - 666889

Dongliang Liu - 701811

Kun Qin - 674258

Xue Jiang - 665401

## How to use

Please run these commands:

bundle install
rake db:create
rake db:migrate
rake weather:getLocation
rake weather:getForecast
rails s

## APIs:

### Weather (http://openweathermap.org/weather-data#current)
http://api.openweathermap.org/data/2.5/weather?lat=-37&lon=144&units=metric

### Lat and Long to Postcode
http://maps.googleapis.com/maps/api/geocode/json?latlng=-37,144&sensor=true

### Postcode to Lat and Long
http://api.geonames.org/postalCodeSearchJSON?postalcode=3023&country=AU&maxRows=1&username=maxzhx
