//
//  result_value.swift
//  CDAKit
//
//  Created by Eric Whitley on 11/30/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

public class CDAKResultValue: NSObject, CDAKThingWithTimes {
  //embedded_in :entry
  public var attributes: [String:String] = [String:String]()
  
  //this is not originally in the model, but found instances where dynamic properties
  // were being referfenced for this - see protocol ThingWithTimes
  public var time: Double?
  public var start_time: Double?
  public var end_time: Double?
  
  override public var description: String {
    return "\(self.dynamicType) => attributes: \(attributes), time: \(time), start_time: \(start_time), end_time: \(end_time)"
  }
  
}

