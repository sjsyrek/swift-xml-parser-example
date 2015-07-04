// main.swift
// SwiftXMLParserExample
//
// Copyright 2015 Steven J. Syrek
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
    var elementNames = ["author", "title", "genre", "price", "publish_date", "description"]
    var currentString: String = ""
    var storingCharacters = false
    var startTime = NSTimeInterval()
    var lastDuration = NSTimeInterval()
    var done = true
    subscript(i: Int) -> Book {                         // so we can index right into the array of results
        return parsedItems[i]
    }
    
    init(fromFileAtPath path: String!) {                // initialize with path to a valid XML file
        XMLfile = NSInputStream(fileAtPath: path)!
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
            print("id: \(item.id)")
            print("author: \(item.author)")
            print("title: \(item.title)")
            print("genre: \(item.genre)")
            print("price: \(item.price)")
            print("publish_date: \(item.publish_date)")
            print("description: \(item.desc)\n")
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
    }
    
    func finishedCurrentItem() {
        parsedItems.append(currentItem!)                // keep track of parsed Book objects
    }
    
    // MARK: - NSXMLParserDelegate
    func parserDidStartDocument(parser: NSXMLParser) {
        startTime = NSDate.timeIntervalSinceReferenceDate()     // simple timer hack
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        done = true
        lastDuration = NSDate.timeIntervalSinceReferenceDate() - startTime
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        if elementName == "book" {
            currentItem = Book()
            if let id: AnyObject? = attributeDict["id"],        // avoiding the pyramid of doom
                   item = currentItem {
                       item.id = id as! String
                       // item.id = String(format: (id! as! NSString) as NSString as String)
            }
        } else if elementNames.contains(elementName) {
            currentString = ""
            storingCharacters = true
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName: String?) {
        if let item = currentItem {
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
                item.price = price.doubleValue
            } else if elementName == "publish_date" {
                item.publish_date = currentString
                // item.publish_date = NSDate(string: currentString)
            } else if elementName == "description" {
                item.desc = currentString
            }
            storingCharacters = false
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if storingCharacters == true {
            currentString += string
        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print(parseError.localizedFailureReason)
        print(parseError.localizedDescription)
    }
    
    // For other methods defined on the NSXMLParserDelegate protocol, see
    // https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSXMLParserDelegate_Protocol/Reference/Reference.html#//apple_ref/occ/intfm/NSXMLParserDelegate/
}

// Test procedures

let path = "/Users/Steven/Transporter/Steve's Cloud/Code/Swift/books.xml"
let myParser = SwiftXMLParser(fromFileAtPath: path)
myParser.start()
myParser.getParsedItems()
print("Last parse took \(myParser.getLastDuration()) seconds.")
myParser[0]     // subscript test
myParser.displayItems()