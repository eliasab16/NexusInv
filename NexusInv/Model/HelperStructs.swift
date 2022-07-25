//
//  HelperStructs.swift
//  NexusInv
//
//  Created by Elias Abunuwara on 2022-07-15.
//

import Foundation

struct Inv: Identifiable {
    var id: String
    
    var brand: String
    var type: String
    var stock: Int
    var nickname : String
    var supplier : String
    var recQuantity: Int
    var boxQuantity: Int
    var costPrice: Int
}

struct Iden: Identifiable {
    var id: String
    
    var name: String
}

struct Project: Identifiable {
    var id = UUID()
    
    var name: String
}
