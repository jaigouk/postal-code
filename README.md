# Post Codes

It provides an api endpoint which

takes a GPS latitude and longitude and

spits out the names of museums around that location grouped by their postcode as JSON.

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

rake db:create

# Japen db by default
# We will import WhosOnFirst administrative and postcode data
rake wof:download_db
rake wof:convert_to_csv
rake wof:import_csv

# For adding extra migrations
rake db:new_migration name=CreateSomething
```

redis

```sh
$ gem install rugged

You need to have CMake and pkg-config installed on your system to be able to build the included version of libgit2. On OS X, after installing Homebrew, you can get CMake with:

$ brew install cmake
```
