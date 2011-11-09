Buster
======

Buster is a universal iOS app for retrieving bus predictions from the MBTA.  Buster uses [AFNetworking](https://github.com/gowalla/AFNetworking) for requesting data from the web and [SMXMLDocument](https://github.com/nfarina/xmldocument) for parsing XML.  For more information about bus predictions check out the [MassDOT/MBTA Real-Time XML TRIAL Feed](http://www.eot.state.ma.us/developers/realtime/).

Overview
------------------

A model object governs the display of route, stop, and vehicle data for each table view.  Each model object requests data using an AFHTTPRequestOperation and parses XML data into an SMXMLDocument.  As each view controller is pushed onto the stack, it initializes a new model object and uses KVO to observe property changes.  In response to observed property changes a view controller might reload table data or display an error message to the user.

Screenshots
-----------

A group of screenshots depicting the flow of Buster in action are shown below.

![routes.png](http://i.imgur.com/HfGvn.png)
![directions.png](http://i.imgur.com/2SmsX.png)

The route list represents a list of all routes the MBTA currently provides XML predictions for.  Selecting a route brings up a list of associated stops.  Inbound and outbound directions are specified via the control at the bottom of the TableView.  Selecting a stop will display of list of predictions for when the next bus will arrive.  No predictions shown indicates the bus is not running.  Selecting a prediction will display a map of where the bus currently is.  Location data is updated by the MBTA about once per minute.


