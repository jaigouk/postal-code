# Postal Code

It provides an api endpoint which takes a GPS latitude and longitude and spits out the names of museums around that location grouped by their postcode as JSON.

**Assumptions:**

- Postalcode data from WhosOnFirst.org covers the countries fully for postal codes
- Postalcode data hasn't been changed since they obtained the administrative & postcode data
- Coverage is [good enough](https://whosonfirst.org/blog/2019/05/13/geonames/) for the domain area

<img src="https://whosonfirst.org/blog/2019/05/13/geonames/images/post-gn.png" width="600px">

## Example result

As an example when doing a request to `/museums?lat=52.494857&lng=13.437641` would generate a response similar to:

```json
{
  "10999": ["Werkbundarchiv – museum of things"],
  "12043": ["Museum im Böhmischen Dorf"],
  "10179": [
    "Märkisches Museum",
    "Museum Kindheit und Jugend",
    "Historischer Hafen Berlin"
  ],
  "12435": ["Archenhold Observatory"]
}
```

## Local setup

We need postgresql and redis to store data.

### Preparing data

```sh
psql
# create user and add username and password to .env
CREATE ROLE postalcode WITH CREATEDB LOGIN SUPERUSER PASSWORD 'postalcode';

# ruby 2.6.3
rvm use 2.6.3
gem instsall bundler

cp .env.example .env
bundle install

rake db:setup

# Japen db by default
# We will import WhosOnFirst administrative and postcode data
rake wof:download_db
rake wof:convert_to_csv
rake wof:import_csv_to_db
rake wof:import_geojson_to_tile38

or

rake wof:setup # to run 4 steps above

# For adding extra migrations
rake db:new_migration name=CreateSomething

# In a new terminal, launch tile38
# https://tile38.com/topics/getting-started/
# tile38-server will use redis://localhost:9851/0 by default
# It will consume about 560MB ram.
tile38-server

# In a new terminal, launch ruby server
# And visit http://localhost:9292
bundle exec rackup

```

http://localhost:9292/museums?lat=52.494857&lng=13.437641

## QA

### Museums

http://localhost:9292/museums?lat=52.494857&lng=13.437641

```json
{"10963":[{"text":"Museumspark","postcode":"10963"},{"text":"Museumsshop","postcode":"10963"}],"10785":[{"text":"Museumsshop","postcode":"10785"}],"12627":[{"text":"Museumswohnung Hellersdorf","postcode":"12627"}],"15562":[{"text":"Museumspark Rüdersdorf","postcode":"15562"}]}
```

### Starbucks Japan search

1. keyword is starbucks
2. coordinate is lng: 35.7020691,lat: 139.7753269

http://localhost:9292/starbucks?lng=139.7753269&lat=35.7020691

result is

```json
{"101-0028":[{"text":"Starbucks","postcode":"101-0028"}],"110-0007":[{"text":"Starbucks","postcode":"110-0007"}],"101-0045":[{"text":"Starbucks","postcode":"101-0045"}],"110-0005":[{"text":"Starbucks","postcode":"110-0005"},{"text":"Starbucks","postcode":"110-0005"}]}
```

Form [35.7020691,139.7753269] to postal code location 101-0062.
google shows that the [distance is 1.6 km](https://www.google.com/maps/dir/'35.7020691,139.7753269'/101-0062,+Japan/@35.7001605,139.7605287,15z/data=!3m1!4b1!4m12!4m11!1m3!2m2!1d139.7753269!2d35.7020691!1m5!1m1!1s0x60188c19f2e5f07d:0x3ca11e47810e362b!2m2!1d139.7632912!2d35.6992105!3e2)

Mapbox doesn't return postcode for that coordinate.