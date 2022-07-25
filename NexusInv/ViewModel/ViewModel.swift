//
//  ViewModel.swift
//  NexusInv
//
//  Created by Elias Abunuwara on 2022-07-15.
//

import Foundation
import Firebase
import FirebaseAuth

class ViewModel: ObservableObject {
    // data structures
    @Published var list = [Inv]()
    @Published var suppliersList = [Iden]()
    @Published var customersList = [Iden]()
    @Published var brandsList = [Iden]()
    @Published var projectsList = [Iden]()
    @Published var projectsDict: [String:String] = [:]
    
    // save the fetched item in the struct instance below
    //@Published var foundItem = Inv(id: "", brand: "", type: "", stock: 0, nickname: "")
    @Published var wasFound = false
    
    // Controlling different views
    @Published var showRegister = false
    @Published var showItemOptions = false
    @Published var showLoadingItemOptions = false
    @Published var isAuto = true
    @Published var isAdding = true
    @Published var isBox = true
    
    // database connection properties
    @Published var barcodeValue = ""
    @Published var itemFoundForDisplay = false
    
    @Published var id = ""
    @Published var brand = ""
    @Published var type = ""
    @Published var stock = 0
    @Published var nickname = ""
    @Published var supplier = ""
    @Published var recQuantity = 0
    @Published var boxQuantity = 1
    @Published var costPrice = 0
    
    @Published var inventoryTotalAmount = 0
    // log in properties
    @Published var loginError = false
    @Published var signedIn = false
    let auth = Auth.auth()
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    
    // fetch all data function
    func getData() {
        self.showLoadingItemOptions = true
        inventoryTotalAmount = 0
        // Get a reference to the database
        let db = Firestore.firestore()
        // Read the docu,emt at a specific path
        db.collection("Inventory").getDocuments { list, error in
            // check for errors
            if error == nil {
                if let list = list {
                    
                    DispatchQueue.main.async {
                        // Get all the documents and create Inv structs
                        self.list = list.documents.map { doc in
                            self.inventoryTotalAmount += (doc["costPrice"] as? Int ?? 0) * (doc["stock"] as? Int ?? 0)
                            // return an Inv struct. The attributes of the documents are accessed as key,items in a dictionary
                            return Inv(id: doc.documentID,
                                       brand: doc["brand"] as? String ?? "",
                                       type: doc["type"] as? String ?? "",
                                       stock: doc["stock"] as? Int ?? 0,
                                       nickname: doc["nickname"] as? String ?? "",
                                       supplier: doc["supplier"] as? String ?? "",
                                       recQuantity: doc["recQuantity"] as? Int ?? 0,
                                       boxQuantity: doc["boxQuantity"] as? Int ?? 0,
                                       costPrice: doc["costPrice"] as? Int ?? 0)
                        }
                        
                        self.showLoadingItemOptions = false
                    }
                }
            }
            else {
                // handle error
            }
        }
    }
    
    // fetch item information to display on the scanner screen (without having to press "scan" button)
    func fetchItemForDisplay(barcode: String) {
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Reference the document
        let docRef = db.collection("Inventory").document(barcode)
        
        docRef.getDocument { (doc, error) in
            DispatchQueue.main.async {
                
                self.barcodeValue = barcode
                
                if let doc = doc, doc.exists {
                    // Document exists
                    // Get relevant data
                    self.id = barcode
                    self.brand = doc["brand"] as? String ?? ""
                    self.type = doc["type"] as? String ?? ""
                    self.stock = doc["stock"] as? Int ?? 0
                    self.nickname = doc["nickname"] as? String ?? ""
                    self.supplier = doc["supplier"] as? String ?? ""
                    self.recQuantity = doc["recQuantity"] as? Int ?? 0
                    self.boxQuantity = doc["boxQuantity"] as? Int ?? 0
                    self.costPrice = doc["costPrice"] as? Int ?? 0
                    
                    // print info on screen
                    self.itemFoundForDisplay = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.itemFoundForDisplay = false
                    }
                } else {
                    // print message
                    self.itemFoundForDisplay = false
                }
            }
        }
        
        
    }
    
    
    // check if a document exists
    func fetchItem(barcode: String, status: Int) {
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // Reference the document
        let docRef = db.collection("Inventory").document(barcode)
        
        docRef.getDocument { (doc, error) in
            DispatchQueue.main.async {
                
                self.barcodeValue = barcode
                
                if let doc = doc, doc.exists {
                    // Document exists
                    // Get relevant data
                    self.id = barcode
                    self.brand = doc["brand"] as? String ?? ""
                    self.type = doc["type"] as? String ?? ""
                    self.stock = doc["stock"] as? Int ?? 0
                    self.nickname = doc["nickname"] as? String ?? ""
                    self.supplier = doc["supplier"] as? String ?? ""
                    self.recQuantity = doc["recQuantity"] as? Int ?? 0
                    self.boxQuantity = doc["boxQuantity"] as? Int ?? 0
                    self.costPrice = doc["costPrice"] as? Int ?? 0
                    
                    // if status == 1 then functions was called from inventory list (to make changes)
                    if status == 1 {
                        self.showItemOptions = true
                    } else if self.isAuto {
                        if self.isAdding {
                            self.updateQuantity(id: self.id, quantity: self.isBox ? self.boxQuantity : 1)
                        } else {
                            self.updateQuantity(id: self.id, quantity: self.isBox ? Int("-" + String(self.boxQuantity))! : Int(-1))
                        }
                    } else {
                        self.showItemOptions = true
                    }
                    self.showRegister = false
                } else {
                    // Document doesn't exist
                    //self.getSupp()
                    self.showItemOptions = false
                    self.showRegister = true
                }
            }
        }
        
        
    }
    
    // Update the quantity in inventory of item "id"
    func updateQuantity(id: String, quantity: Int) {
        
        var newQuantity = self.stock + quantity
        
        // Get a reference to the database
        let db = Firestore.firestore()
        
        if (newQuantity < 0) {
            newQuantity = 0
        }
        
        db.collection("Inventory").document(id).updateData(["stock" : newQuantity])
    }
    
    
    // update item information - not including quantity
    func updateData(id: String, brand: String, type: String, nickname: String, supplier: String, quantity: Int, recQuantity: Int, boxQuantity: Int, costPrice: Int) {
        // Get a reference to the database
        let db = Firestore.firestore()
        
        // update given data, if none given, just
        db.collection("Inventory").document(id).updateData(["brand": brand,
                                                            "type": type,
                                                            "nickname": nickname,
                                                            "supplier": supplier,
                                                            "quantity": quantity,
                                                            "recQuantity": recQuantity,
                                                            "boxQuantity": boxQuantity,
                                                            "costPrice": costPrice])
        
        // call get the data to get the updated list and properties
        self.fetchItem(barcode: id, status: 0)
        self.getData()
    }
    
    
    // Add item to inventory
    func addData(id: String, brand: String, type: String, stock: Int, nickname : String, supplier: String, recQuantity: Int, boxQuantity: Int, costPrice: Int) {
        // Get a reference to the database
        let db = Firestore.firestore()
        // Add a document to a collection, using the barcode serial number as its unique ID
        db.collection("Inventory").document(id).setData(["brand": brand,
                                                         "type": type,
                                                         "stock": stock,
                                                         "nickname": nickname.isEmpty ? (brand + type) : nickname,
                                                         "supplier": supplier,
                                                         "recQuantity": recQuantity,
                                                         "boxQuantity": boxQuantity,
                                                         "costPrice": costPrice]) {error in
            // Check for errors
            if error == nil {
                self.getData()
                
            }
            else {
                // Handle the error
                print("error")
            }
        }
    }
    
    
    // sign in function
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email,
                    password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                self?.loginError = true
                return
            }
            
            // added self"?" and [weak self] above to prevent any memory leaks
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    
    // sign out function
    func signOut() {
        try? auth.signOut()
        self.signedIn = false
    }
    
    
    // delete entire document
    func deleteData(id: String) {
        // Get a reference
        let db = Firestore.firestore()
        
        // Specify the document to delete
        // db.collection("tasks").document(toDelete.id).delete()
        db.collection("Inventory").document(id).delete { error in
            // Check for errors
            if error == nil {
                // No errors
                
                // Update te UI from the main threade
                DispatchQueue.main.async {
                    // This will iterate over the list, and for each item, it will compare its id, then delete it if it's a match
                    self.list.removeAll { todo in
                        // Check for the todo to remove
                        return todo.id == id
                    }
                }
            }
        }
    }
    
    
    // SUPPLIERS FUNCTIONS //
    
    // get suppliers
    func getIden(collection: String) {
        // Get a reference to the database
        let db = Firestore.firestore()
        // Read the docu,emt at a specific path
        db.collection(collection).getDocuments { list, error in
            // check for errors
            if error == nil {
                // store the retrieved data in `list` and assign it to suppliersList
                if let identityList = list {
                    
                    DispatchQueue.main.async {
                        if collection == "Suppliers" {
                            // Get all the documents and create Iden structs
                            self.suppliersList = identityList.documents.map { doc in
                                // return an Inv struct. The attributes of the documents are accessed as key,items in a dictionary
                                return Iden(id: doc.documentID,
                                           name: doc["name"] as? String ?? "")
                            }
                        }
                        else if collection == "Customers" {
                            self.customersList = identityList.documents.map { doc in
                                return Iden(id: doc.documentID,
                                           name: doc["name"] as? String ?? "")
                            }
                        }
                        else if collection == "Brands" {
                            self.brandsList = identityList.documents.map { doc in
                                return Iden(id: doc.documentID,
                                           name: doc["name"] as? String ?? "")
                            }
                        }
                        // app was crashing on projects
//                        else if collection == "Projects" {
////                            self.projectsList = identityList.documents.map { doc in
////                                return Iden(id: doc.documentID,
////                                            name: doc["name"] as? String ?? "")
////                            }
//                            identityList.documents.forEach({ rawDoc in
//                                let doc = rawDoc.data()
//                                self.projectsDict[doc["name"] as! String] = (doc["subProjects"] as! String)
//                            })
//                        }
                    }
                }
            }
            else {
                // handle error
            }
        }
    }
    
    
    // call getIden on all collections
    func getAll() {
        self.getIden(collection: "Suppliers")
        self.getIden(collection: "Customers")
        self.getIden(collection: "Brands")
        self.getIden(collection: "Projects")
    }
    
    
    // add supplier, customer, or brand
    func addIden(collection: String, name: String) {
        // Get a reference to the database
        let db = Firestore.firestore()
        // Add the document, let firestore pick an id by using addDocument() instead of document(id).setData
        db.collection(collection).document(name).setData(["name": name])
        
        self.getIden(collection: collection)
    }
    
    
    // update data in Inventory that meets a condition
    func updateIden(collection: String, field: String, oldValue: String, newValue: String) {
        let db = Firestore.firestore()
        db.collection("Inventory").whereField(field, isEqualTo: oldValue)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
//                        db.collection("Inventory").document(document.documentID).updateData(["supplier": newValue])
                        
                        let ref = document.reference

                        ref.updateData([field: newValue])
                    }
                }
                self.getIden(collection: collection)
            }
    }
    
    
    // delete
    func deleteIden(collection: String, id: String) {
        let db = Firestore.firestore()
        db.collection(collection).document(id).delete { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.list.removeAll { todo in
                        return todo.id == id
                    }
                }
            }
        }
        
        self.getIden(collection: collection)
    }
    
    
    // projects
    
    func addProject(id: String, name: String, subProjects: [Project]) {
        let db = Firestore.firestore()
        db.collection("Projects").document(id).setData(["name": name,
                                                        "subProjects": subProjects]) { error in
            
            if error == nil {
                // get project list
            }
            else {
                // handle error
            }
        }
    }
}
