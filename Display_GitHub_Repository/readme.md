## Read through Test Assignment (03:30)


## Rough Road Map (04:00)
* Some Network util class is needed
* Storyboard vs. Incode decision?
* TableView out of convenience with custom Cell
* Initial loading on main thread okay? How big is the response, paging mechanism possible?

## Connect to API via Postman to get a feel (08:33)
### Repository API analysis
* The Response is quite huge, so definitely parse only parts of it
* It has all the required information
### Commits API analysis
* The API also returns quite a bit data set, definitely parse only parts

## Write Data Models (07:20)
* The data model should, for now, contain all the necessary information, nothing to fancy for the beginning.
* There should be two data models, for the repository itself and one for parsing the commits.
* Both data models should conform to codable for ease of parsing.

## Network Util class (39:51)
* The class will make use of URLSessions, and it should probably be a shared instance.
* It contains two functions for fetching the repositories and the commits.
* Maybe I can use generics to cut it down to one function since the body looks identical?

## Embed TableView in ViewController (04:26)
* ViewController will be added via Storyboard out of convenience for now
* Followed by all Delegates and Datasources

## Write ViewModel for better separation (12:05)
* The ViewModel should make the Network request upon ViewController init
* It should store the data, accessible for ViewController
* Notify ViewController via Delegate

## Connect ViewController and ViewModel (08:15)
* Display ActivityIndicator while first request is loading
* Upon ViewController delegate call refresh tableView to layout

## Write custom TableViewCell (34:23)
* Custom cell should be a separate xib.
* Outlets will be set from viewController cellForRow for convenience

## Make async call after TableView didLayout (01:05:39)
* Dispatch multiple requests, for all relevant commits, at a time in the background

## Update the Cell after Commit request (25:17)
* I'll update the data model in the completion block for the request and then reload each cell


### Total time spent: (03:33:19)

I had some problems with the DispatchGroup setup, but after all, it did not take too long. The second most time was spend on updating the Repository Model with the Commit-SHA. I had an unfortunate problem with the GitHub API itself. I was debugging for ~5minutes why it was not updating the ViewModel until I found out that the request was failing because the API had blocked my IP - after activating a VPN I went back to work. :thumbsup.
