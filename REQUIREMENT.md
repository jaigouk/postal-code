## Req


### intro

Hi Jaigouk,

Thanks again for your time yesterday.
We would like to invite you to the next stage of the interview, this technical task that we mentioned during our call. You’ll find the description below.

### Backend Developer Code Exercise

Hello! In this stage of the interview process, we would like to see what kind of code you write.

Don’t worry there won’t be any trick questions, it is more grounded in the real world and serves as an example of something that you would have to do on a day-to-day basis as a backend developer. Furthermore, this will also serve as a conversation starter for the technical interview where we will go over the code together and talk about it.

 ### Brief

We’re looking for a small Ruby API application providing an endpoint which takes a GPS latitude and longitude and spits out the names of museums around that location grouped by their postcode as JSON.

Mapbox provides a handy API endpoint for fetching that around a location (you will need to create a free account for getting an API key to use their API). You can find the relevant Mapbox documentation here: https://docs.mapbox.com/api/search/#mapboxplaces.

As an example when doing a request to `/museums?lat=52.494857&lng=13.437641` would generate a response similar to:

```
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

Note that some places in Mapbox don’t have PostalCode, for example in Japan. The decision on how to handle these museums is up to you.

 ### In conclusion

We value your personal time and tried to frame this exercise to be solvable in a couple of hours.

We’re looking for API design, tested and documented code. If possible, please send us your solution back within one week, but if you need more time please reach out to us and keep us in the loop.

The expected final solution should be an archive (with the .git directory included) or a git bundle.

And feel free to ask us in case you have questions about the exercise.

Best regards,
Christof


### contact

Mercedes-Benz.io
Breitscheidstrasse 10
70174 Stuttgart (Germany)

Mercedes-Benz.io | Driving Digital Future. Now.
We are hiring: mercedes-benz.io/jobs

