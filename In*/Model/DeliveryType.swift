//
//  DeliveryType.swift
//  In*
//
//  Created by Mohammad Sulthan on 21/08/22.
//

import Foundation
import SwiftyMenu

struct DeliveryType: SwiftyMenuDisplayable {
    let id: Int
    let name: String
    
    public var displayableValue: String {
        return self.name
    }
    
    public var retrievableValue: Any {
        return self.id
    }
}
