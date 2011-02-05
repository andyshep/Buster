Buster
======

Buster is a universal iOS app for retrieving bus predictions from the MBTA.  Buster uses [ASIHTTPRequest](http://allseeing-i.com/ASIHTTPRequest/) for retrieving data from the web and [TouchXML](https://github.com/TouchCode/TouchXML) for parsing XML from the MBTA.  For more information about bus predictions check out the [MassDOT/MBTA Real-Time XML TRIAL Feed](http://www.eot.state.ma.us/developers/realtime/).

Overview
------------------

As each table view is displayed, an NSOperation is created to handle the fetching and parsing of XML.  Each view controller uses KVO to observe model changes from completed NSOperations.

Screenshots
-----------

A group of screenshots depicting the flow of Buster in action are shown below.

![buster-flow.png](http://i.imgur.com/kd4Rm.png)

The route list represents a list of all routes the MBTA currently provides XML predictions for.  Selecting a route brings up a list of associated stops.  Inbound and outbound directions are specified via the control at the bottom of the TableView.  Selecting a stop will display of list of predictions for when the next bus will arrive.  No predictions shown indicates the bus is not running.  Selecting a prediction will display a map of where the bus currently is.  Location data is updated by the MBTA about once per minute.

![buster-ipad.png](http://i.imgur.com/63DyX.png)


