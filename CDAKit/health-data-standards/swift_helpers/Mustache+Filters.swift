//
//  Mustache+Filters.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/22/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

class MustacheFilters {

  static let UUID_generate = Filter { (value: Any? ) in
    let uuid_string = NSUUID().UUIDString
    return Box(uuid_string)
  }

  //Ruby -> :number -> 20081225143505
  static let DateAsNumber = Filter { (box: MustacheBox) in
    
    if box.value == nil {
      return Box(NSDate().stringFormattedAsHDSDateNumber)
    }
    
    switch box.value {
    case let int as Int:
      let d = NSDate(timeIntervalSince1970: Double(int))
      return Box(d.stringFormattedAsHDSDateNumber)
    case let double as Double:
      let d = NSDate(timeIntervalSince1970: double)
      return Box(d.stringFormattedAsHDSDateNumber)
    case let date as NSDate:
      return Box(date.stringFormattedAsHDSDateNumber)
    default:
      return Box()
    }
  }

  static let DateAsHDSString = Filter { (box: MustacheBox) in
    
    if box.value == nil {
      return Box(NSDate().stringFormattedAsHDSDate)
    }
    
    switch box.value {
    case let int as Int:
      let d = NSDate(timeIntervalSince1970: Double(int))
      return Box(d.stringFormattedAsHDSDate)
    case let double as Double:
      let d = NSDate(timeIntervalSince1970: double)
      return Box(d.stringFormattedAsHDSDate)
    case let date as NSDate:
      return Box(date.stringFormattedAsHDSDate)
    default:
      return Box()
    }
  }
  
  static let value_or_null_flavor = Filter { (box: MustacheBox) in

    switch box.value {
    case let int as Int:
      let d = ViewHelper.value_or_null_flavor(Double(int))
      return Box(d)
    case let int as Double:
      let d = ViewHelper.value_or_null_flavor(int)
      return Box(d)
    default:
      return Box()
    }

  }

  static let oid_for_code_system = Filter { (box: MustacheBox) in
    
    switch box.value {
    case let code_system as String:
      let d = CDAKCodeSystemHelper.oid_for_code_system(code_system)
      return Box(d)
    default:
      return Box()
    }
    
  }
  
  static let is_bool = Filter { (box: MustacheBox) in
    
    switch box.value {
    case let val as Bool:
      return Box(true)
    case let val as Bool?:
      return Box(true)
    case let val as String:
      //.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())      
      if val.lowercaseString == "true" || val.lowercaseString == "false" {
        return Box(true)
      }
      return Box(false)
    default:
      return Box(false)
    }
    
  }

  static let is_numeric = Filter { (box: MustacheBox) in
    
    switch box.value {
    case let val as Int:
      return Box(true)
    case let val as Int?:
      return Box(true)
    case let val as Double:
      return Box(true)
    case let val as Double?:
      return Box(true)
//    case let val as Float:
//      return Box(true)
//    case let val as Float?:
//      return Box(true)
    case let val as String:
      if let val = Double(val) {
        return Box(true)
      }
//      if let val = Float(val) {
//        return Box(true)
//      }
      return Box(false)
    default:
      return Box(false)
    }

  }

  
  
  //this is a serious abuse of the library...
  static let codeDisplayForEntry = Filter { (box: MustacheBox, info: RenderingInfo) in
    
    let args = info.tag.innerTemplateString
    var opts: [String:Any] = [:]
    
    opts = CDAKUtility.convertStringToDictionary(args)
    //print("Got ops for ... \n \(opts) \n")
    
    var out = ""
    //print("box = \(box)")
    
    //String:MustacheBox
    //mustacheBox.value
    
    if let boxValues = box.value as? [String:MustacheBox] {
      var entryValues: [String:Any?] = [:]
      for(key, value) in boxValues {
        //print(value.value)
        entryValues[key] = (value.value as Any?)
      }
      print("entryValues = \(entryValues)")
      //what KIND of entry are we? - we're going to cheat and abuse the "class_name" field we set up
      // for this we don't really seem to need it (great)
      let entry = CDAKEntry(event: entryValues)
      print("created an entry")
      out = ViewHelper.code_display(entry, options: opts)
    }
    
//    if let entry = box.value as? CDAKEntry {
//      out = ViewHelper.code_display(entry, options: opts)
//    } else {
//      //print("couldn't cast entry")
//      //print("entry = '\(box.value)'")
//    }
    
    return Rendering(out)
  }

  
}