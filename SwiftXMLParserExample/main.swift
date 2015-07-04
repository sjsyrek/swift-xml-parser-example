// SwiftXMLParserExample
// main.swift
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
class Book: NSObject {                                  // object class for base element in XML file after <root>
    var id: String = ""
    var author: String = ""
    var title: String = ""
    var genre: String = ""
    var price: Double = 0.0
    var publish_date: String = ""                       // maybe get NSDate to work here
    var desc: String = ""                               // I should probably strip out the \n's
}

// MARK: - SwiftXMLParser
class SwiftXMLParser: NSObject {
    var XMLfile: NSInputStream
    var parser: NSXMLParser
    var currentItem: Book?
    var parsedItems: [Book]?                            // final result of parse is stored here
    var elementNames = ["author", "title", "genre", "price", "publish_date", "description"]
    var currentString: String = ""
    var storingCharacters = false
    var startTime = NSTimeInterval()
    var lastDuration = NSTimeInterval()
    var done = true
    subscript(i: Int) -> Book {                         // so we can index right into the array of results
        if let items = getParsedItems() {
            return items[i]
        } else {
            return Book()                               // need to return something here in case the parse fails
        }
    }
    
    init(fromFileAtPath path: String!) {                // initialize with path to a valid XML file
        XMLfile = NSInputStream(fileAtPath: path)!
        parser = NSXMLParser(stream: XMLfile)
    }
    
    func getParsedItems() -> [Book]? {
        return parsedItems
    }
    
    func getLastDuration() -> NSTimeInterval {
        return lastDuration
    }
    
    func displayItems() {
        if let items = getParsedItems() {
            for item in items {
                print("id: \(item.id)")
                print("author: \(item.author)")
                print("title: \(item.title)")
                print("genre: \(item.genre)")
                print("price: \(item.price)")
                print("publish_date: \(item.publish_date)")
                print("description: \(item.desc)\n")
            }
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
        parsedItems!.append(currentItem!)               // keep track of parsed Book objects
    }
    
    // MARK: - NSXMLParserDelegate
    func parserDidStartDocument(parser: NSXMLParser) {
        startTime = NSDate.timeIntervalSinceReferenceDate()     // simple timer hack
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        done = true
        lastDuration = NSDate.timeIntervalSinceReferenceDate() - startTime
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "book" {
            currentItem = Book()
            if let id: AnyObject? = attributeDict["id"],        // avoiding the pyramid of doom
                item = currentItem {
                    item.id = id as! String
            }
        } else if elementNames.contains(elementName) {
            currentString = ""
            storingCharacters = true
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if let item = currentItem {
            switch elementName {
            case "book":
                finishedCurrentItem()
            case "author":
                item.author = currentString
            case "title":
                item.title = currentString
            case "genre":
                item.genre = currentString
            case "price":
                let price = currentString as NSString
                item.price = price.doubleValue
            case "publish_date":
                item.publish_date = currentString
            case "description":
                item.desc = currentString
            default:
                break
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

extension SwiftXMLParser: NSXMLParserDelegate {} // Make parser objects their own delegates

// Test procedures
let path = "/Users/Steven/Transporter/Steve's Cloud/Code/Swift/books.xml"
let myParser = SwiftXMLParser(fromFileAtPath: path)
myParser.start()
print("Last parse took \(myParser.getLastDuration()) seconds.")
myParser.displayItems()