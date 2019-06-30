# Postal Code

It provides an api endpoint which takes a GPS latitude and longitude and spits out the names of museums around that location grouped by their postcode as JSON.

Assumption:

- postcode data from WhosOnFirst.org covers the countries fully for postal codes
- postcode data hasn't been changed since they obtained the administrative & postcode data

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

or

rake wof:setup # to run 3 steps above

# For adding extra migrations
rake db:new_migration name=CreateSomething

# In a new terminal, launch tile38
# https://tile38.com/topics/getting-started/
# tile38-server will use redis://localhost:9851/0 by default
tile38-server

redis-cli -p 9851
```
