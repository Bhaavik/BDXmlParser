//
//  BdXmlParser.swift
//  Hrinnova
//
//  Created by Bhavik doshi on 7/6/16.
//  Copyright © 2016 Cygnet Infotech. All rights reserved.
//  This class Will be use to parse Xml Data.



import Foundation
class BbXmlParser : NSObject,NSXMLParserDelegate
{
    var parser = NSXMLParser()
    //    var arrStack = Array()
    var arrStack:[AnyObject]!
    //    var elements = NSMutableDictionary()
    var elements:AnyObject!
    //    var textInProgress = NSMutableString()
    var textInProgress:String!
    
    
    override init()
    {
    }
    
    //Pass Xml Data and Fetch Dictionary From it.
    func getdictionaryFromXmlData(xmldata:NSData) -> NSDictionary
    {
        //        self.arrStack.addObject(self.elements)
        self.arrStack.append(self.elements)
        self.parser  = NSXMLParser.init(data: xmldata)
        self.parser.delegate = self
        self.parser.parse()
        let dictResponse = self.arrStack[0] as! NSDictionary
        return dictResponse
    }
    
    //Pass XmlString and Fetch Dictionary From it.
    //We need to initially convert String to Data
    func getdictionaryFromXmlString(xmldata:String) -> NSDictionary
    {
        
        let  data = xmldata.dataUsingEncoding(NSUTF8StringEncoding)
        return self.getdictionaryFromXmlData(data!)
        
    }
    
    
    // MARK: XML Delegate Methods
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        //Create dictionary for currnt Level
        let parentDict = arrStack.last
        
        //Create Child dict and Add attributes dict in to that
        
        let childDict = NSMutableDictionary()
        childDict.addEntriesFromDictionary(attributeDict)
        
        //check any item for same Node Exist?
        //if there than we need to create array for same
        let existingValue = parentDict![elementName]
        
        if (existingValue != nil)
        {
            var array:[AnyObject] = Array()
            
            if existingValue is NSMutableArray
            {
                //use alreaddy created array
                array = existingValue as! [AnyObject]
            }
            else
            {
                //replace child dict to array of alreaddy created item so managing array
                //array.addObject(existingValue!)   // Harshit
                array.append(existingValue!!)
                //parentDict!.setValue(array, forKey: elementName)  // Harshit
                parentDict?.setValue(array, forKey: elementName)
            }
            
            //array.addObject(childDict) // Harshit
            array.append(childDict)
        }
        else
        {
            //No current value update dictionary
            //parentDict.setValue(childDict, forKey: elementName) // Harshit
            parentDict?.setValue(childDict, forKey: elementName)
        }
        //update stack
        //        arrStack.addObject(childDict) // Harshit
        arrStack.append(childDict)
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        //update parent dict with text info i.e /n
        let dictInProgress = arrStack.last
        // Set the text property can remove this but apple recommending this
        
        if self.textInProgress.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            
            //            dictInProgress.setValue(textInProgress, forKey: "text")
            dictInProgress?.setValue(textInProgress, forKey: "text")
            //textInProgress = NSMutableString()    // Harshit
            textInProgress = ""
        }
        //Remove current node
        //arrStack.removeLastObject()   // Harshit
        arrStack.removeLast()
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        //        textInProgress.appendString(string)   // Harshit
        textInProgress = textInProgress + string
    }
}