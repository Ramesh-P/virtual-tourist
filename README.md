# Virtual Tourist
![Alt Text](https://github.com/Ramesh-P/virtual-tourist/blob/master/Virtual%20Tourist/Assets.xcassets/AppIcon.appiconset/Icon-60%403x.png)
## Overview
Virtual Tourist allows users specify travel locations around the world, and create virtual photo albums for each location. The locations and associated photo albums are stored in Core Data. The complete project specification for Virtual Tourist can be found [here](https://docs.google.com/document/d/1j-UIi1jJGuNWKoEjEk09wwYf4ebefnwcVrUYbiHh1MI/pub?embedded=true)
## Specification
Virtual Tourist is built and tested for the following software versions:
* Xcode 8.1
* iOS 10.0 (Minimum)
* Swift 3.0.1 
## Preview
![virtual-tourist](https://cloud.githubusercontent.com/assets/25907551/24127950/f569d38c-0dae-11e7-823f-4e83f801869e.gif)
## Features
Virtual Tourist incorporates all the features stipulated by Udacity and extra credit and additional features as listed below
### Extra Credit Features
Virtual Tourist includes the following extra credit features:
* Persisting map zoom is implemented using the “Preset” entity in the core data model. This is an additional entity beyond required Pin and Photo entities
* Enables the user to drop and drag the pin while adding a new pin
* Images for the pin location are downloaded immediately upon adding a new pin without the user having to navigate to the photo album view
### Additional Features
Virtual Tourist is beautifully designed with the following additional features:
#### Travel Locations Map View
* Map tile overlay adds aesthetic beauty to the app
* Matching custom annotations (pins) adds to the visual appeal of the app
* Enables the user either to remove all pins or to remove individual pin(s) as desired.
  * This enhances the user experience; without this, the user would have to comb through the entire map to remove unwanted pins
  * This improves app performance, as this frees up storage space otherwise spent on unused pins and their associated photos
* Enables the user to reset map span (zoom) to normal size
  * This is highly convenient for the user to quickly zoom-out when reviewing photos from multiple locations
* Photos are selected from random groups between date posted, date taken, interestingness, and relevance
* Apple style edit menu provides a familiar user interface
* Context sensitive user actions are provided through a banner at the bottom
#### Photo Album View
* Pin geolocation is displayed as readable address
  * This enhances the user experience, as this helps to correlate the photos to the location where it is taken
* Photos are displayed along with their title
  * This enhances the user experience, as this provides context for each photo
* Apple style edit menu provides a familiar user interface
* Context sensitive user actions are provided through a banner at the bottom
## Authors
* [Ramesh Parthasarathy](mailto:msg.rameshp@gmail.com)
## License
Virtual Tourist is licensed under [MIT License](https://github.com/Ramesh-P/virtual-tourist/blob/master/LICENSE)
## Credits
Virtual Tourist uses icons and images from:
<pre>http://www.flaticon.com</pre>
<pre>http://www.freepik.com</pre>
Virtual Tourist uses map tiles from:
<pre>https://www.openstreetmap.org</pre>
<pre>https://carto.com</pre>
<pre>http://maps.stamen.com</pre>
Attributions can be found on `Credits.rtf` and/or elsewhere within the code files
