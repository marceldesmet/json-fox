#INCLUDE json-fox.h
Do main with "loaddep"
CLEAR
* Example usage of ParseUrl function
LOCAL loWebUtils, loUrlParts, lcUrl

* Create an instance of the WebUtils class
loWebUtils = CREATEOBJECT("WebUtils")

* Example URL
lcUrl = "https://www.example.com/path/to/resource?param1=value1&param2=value2#section"

* Parse the URL
loUrlParts = loWebUtils.ParseUrl(lcUrl)

* Display the URL parts
? "Url: " + lcUrl
? "Protocol: " + loUrlParts.Protocol
? "Host: " + loUrlParts.Host
? "Path: " + loUrlParts.Path
? "QueryString: " + loUrlParts.QueryString
? "Fragment: " + loUrlParts.Fragment