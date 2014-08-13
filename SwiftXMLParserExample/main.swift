//
//  main.swift
//  SwiftXMLParserExample
//
//  Created by Steven Syrek on 7/24/14.
//  Copyright (c) 2014 Steven Syrek. All rights reserved.
//
// SwiftXMLParserExample for file books.xml downloaded from: http://msdn.microsoft.com/en-us/library/ms762271(v=vs.85).aspx
// Loosely based on Apple's XMLPerformance example: https://developer.apple.com/library/ios/samplecode/XMLPerformance

import Cocoa
import Foundation

// MARK: - Book

class Book: NSObject {                                  // object class for base element in XML file after root
    
    var id: String = ""
    var author: String = ""
    var title: String = ""
    var genre: String = ""
    var price: Double = 0.0
    var publish_date: String = ""                       // need to get NSDate to work here
    var desc: String = ""                               // I should probably strip out the \n's
}

// MARK: - SwiftXMLParser

class SwiftXMLParser: NSObject, NSXMLParserDelegate {
    
    var XMLfile: NSInputStream
    var parser: NSXMLParser
    var currentItem: Book?
    var parsedItems: [Book] = []                        // final result of parse is stored here
    var currentString: String = ""
    var storingCharacters = false
    var startTime = NSTimeInterval()
    var lastDuration = NSTimeInterval()
    var done = true
    
    subscript(i: Int) -> Book {                         // so we can index right into the array of results
        return parsedItems[i]
    }
    
    init(fromFileAtPath path: String!) {                // initialize with path to a valid XML file
        XMLfile = NSInputStream(fileAtPath: path)
        parser = NSXMLParser(stream: XMLfile)
        super.init()
    }
    
    func getParsedItems() -> [Book] {
        return parsedItems
    }
    
    func getLastDuration() -> NSTimeInterval {
        return lastDuration
    }
    
    func displayItems() {
        for item in parsedItems {
            println("id: \(item.id)")
            println("author: \(item.author)")
            println("title: \(item.title)")
            println("genre: \(item.genre)")
            println("price: \(item.price)")
            println("publish_date: \(item.publish_date)")
            println("description: \(item.desc)\n")
        }
    }
    
    func start() {                                      // call after init with an XML file to begin parse
        currentItem = nil
        parsedItems = []
        currentString = ""
        readAndParse()
    }
    
    func readAndParse() {
        parser.delegate = self                          // make this object the delegate for the parser object
        done = false
        parser.parse()
        
        //        The code below might be useful if you want to open a connection to an XML file located remotely.
        //        See Apple's example code, and move the parse function to a different method that runs when it receives
        //        a message that the remote connection is open, and test here to make sure the connection is active.
        //
        //        if parser.parse() {
        //            do {
        //
        //                // The corresponding code in Objective-C for this run loop is:
        //                // [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]
        //                // Swift doesn't trust NSDate.distantFuture() to return an object instead of nil, so we have
        //                // to force the type cast with the 'as' operator. Not actually sure I need a run loop here, but
        //                // the code worked so I left it in for now. Probably shouldn't test against the return value of parse().
        //
        //                NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture() as NSDate)
        //            } while !done
        //        }
        
    }
    
    func finishedCurrentItem() {
        parsedItems.append(currentItem!)                // keep track of parsed Book objects
    }
    
    // MARK: - NSXMLParserDelegate
    
    func parserDidStartDocument(parser: NSXMLParser!) {
        startTime = NSDate.timeIntervalSinceReferenceDate()     // simple timer hack
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        done = true
        lastDuration = NSDate.timeIntervalSinceReferenceDate() - startTime
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        if elementName == "book" {
            currentItem = Book()
            if let id: AnyObject? = attributeDict["id"] {
                if let item = currentItem? {
                    item.id = String(format: id! as NSString)           // do I need all this optional unwrapping?
                }
            }
        } else if elementName == "author" || elementName == "title" || elementName == "genre" || elementName == "price" || elementName == "publish_date" || elementName == "description" {
            currentString = ""
            storingCharacters = true
        }
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        if let item = currentItem? {                            // I would like to make an abstract version of this
            if elementName == "book" {
                finishedCurrentItem()
            } else if elementName == "author" {
                item.author = currentString
            } else if elementName == "title" {
                item.title = currentString
            } else if elementName == "genre" {
                item.genre = currentString
            } else if elementName == "price" {
                let price = currentString as NSString
                item.price = price.doubleValue                  // isn't it stupid that I have to cast to NSString?
            } else if elementName == "publish_date" {
                item.publish_date = currentString
                // item.publish_date = NSDate(string: currentString)
            } else if elementName == "description" {
                item.desc = currentString
            }
            storingCharacters = false
        }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        if storingCharacters == true {
            currentString += string
        }
    }
    
    func parser(parser: NSXMLParser!, parseErrorOccurred parseError: NSError!) {
        println(parseError.localizedFailureReason)
        println(parseError.localizedDescription)
        // other error handling (see http://nomothetis.svbtle.com/error-handling-in-swift)
    }
    
    // For other methods defined on the NSXMLParserDelegate protocol, see
    // https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSXMLParserDelegate_Protocol/Reference/Reference.html#//apple_ref/occ/intfm/NSXMLParserDelegate/
}

// Test procedures

let path = "/Users/Steven/Documents/Code/Xcode/books.xml"
let myParser = SwiftXMLParser(fromFileAtPath: path)
myParser.start()
myParser.getParsedItems()
println("Last parse took \(myParser.getLastDuration()) seconds.")
myParser[0]
myParser.displayItems()