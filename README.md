# SwiftXMLParserExample
## An example of how to use NSXMLParser from the Cocoa library to parse XML in Swift
### Updated for Swift 2.0 and Xcode7-Beta2

This is a working example of an XML parser written in Swift but using Cocoa APIs to handle the heavy lifting. It’s based partly on one of Apple’s own example applications and is presently designed to read a specific XML file (included) but could be generalized and made much more Swifty. It’s only a preliminary experiment, and I am not a professional developer. There is also quite a bit that could be done to make this code conform to best Swift practice (such as it is). Feel free to borrow from this repository if you think it could be useful for your own projects.

###### Note: make sure you update the `path` constant in the test section for your own system.

Changelog

- 2015-07-04: Updated for Swift 2.0. The project builds and runs successfully in Xcode7-Beta2 on my machine, but it still does not seem to work in a playground.

- 2014-07-25: The code works in playground and compiles to executable in Xcode6-Beta3 on my machine, but doesn't seem to work in Beta4.

- 2014-08-13: Code works in compiler but not playground in Beta 5 (some issue with NSXMLParser).
