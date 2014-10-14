SwiftXMLParserExample
=====================

This is a working example of an XML parser written in Swift but using
Objective-C APIs to handle the heavy lifting. It’s based partly on one
of Apple’s own example applications. It is presently designed to read a
specific XML file but could be generalized and made much more Swifty.
It’s only a preliminary experiment, and I am not a professional developer.

Note: make sure you update the path constant in the test section for your own system

2014-07-25: The code works in playground and compiles to executable in Xcode6-Beta3 on my machine,
but doesn't seem to work in Beta4.

2014-08-13: Code works in compiler but not playground in Beta 5 (some issue with NSXMLParser)

I haven't tested this with Swift 1.0 yet, but I'm thinking about rewriting it to be more generic and useful now that the language is ready for production use.
