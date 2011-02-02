Buster
======

Buster is a universal iOS app for retrieving bus predictions from the MBTA.  Buster uses [ASIHTTPRequest](http://allseeing-i.com/ASIHTTPRequest/) for retrieving data from the web and [TouchXML](https://github.com/TouchCode/TouchXML) for parsing XML from the MBTA.  For more information about bus predictions please visit the [MassDOT/MBTA Real-Time XML TRIAL Feed](http://www.eot.state.ma.us/developers/realtime/).

Screenshots
-----------

Some obligatory screenshots depicting Buster in action are shown below.

![route-list.png](/docs/images/route-list.png)
The route list represents a list of all bus routes the MBTA current provides XML predictions for.

![stop-list.png](/docs/images/stop-list.png)
Selecting a route brings up a list of associated stops.  Inbound and outbound directions are specified via the UISegmentedControl at the bottom of the UITableView

![prediction-list.png](/docs/images/prediction-list.png)
Selecting a stop will display of list of predictions for when the next bus will arrive.  No predictions shown indicates the bus is not running.

![location-view.png](https://github.com/andyshep/Buster/raw/master/docs/images/location-view.png)
Selecting a prediction will display a map of where the bus currently is.  Location data is updated by the MBTA about every 1 minute. 


