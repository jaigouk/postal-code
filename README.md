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

## Note

some places in Mapbox don’t have postcodes, for example in Japan.

```sh

bin/wof-fetchers/wof-dist-fetch-darwin -inventory https://dist.whosonfirst.org/sqlite/inventory.json -dest /Users/jkim/wof_data -include 'whosonfirst-data-postalcode-*-latest.db'

# https://whosonfirst.org/blog/2018/02/20/wof-in-a-box-part3/
# https://github.com/whosonfirst/es-whosonfirst-schema

$ gem install rugged

You need to have CMake and pkg-config installed on your system to be able to build the included version of libgit2. On OS X, after installing Homebrew, you can get CMake with:

$ brew install cmake
```

1. fetch sqlite database
2. import sqlite into postgres
3. fetch geojson

https://tutorialinux.com/today-learned-migrating-sqlite-postgres-easy-sequel/