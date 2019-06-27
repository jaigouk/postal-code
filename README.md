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

```
docker pull pelias/libpostal-service
```
