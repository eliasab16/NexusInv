//
//  SuppliersView.swift
//  NexusInv
//
//  Created by Elias Abunuwara on 2022-07-15.
//

import SwiftUI

struct SuppliersView: View {
    @EnvironmentObject var model: ViewModel
    
    @State var supplier = ""
    @State var supplierToDelete = ""
    @State var supplierToEdit = ""
    @State var supplierNew = ""
    
    @State private var isAdding = false
    @State var showAddedAlert = false
    @State var showDeleteWarning = false
    @State var showDeletedAlert = false
    @State var showEditWindow = false
    
    var body: some View {
        ZStack {
            VStack {
                Form {
                    // text field to add a new supplier to the list
                    if isAdding {
                        TextField("שם ספק", text: $supplier)
                        Button(action: {
                            if supplier.count > 1 {
                                model.addIden(collection: "Suppliers", name: supplier)
                                showAddedAlert = true
                                // stop alert after 1 second
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.showAddedAlert = false
                                }
                            }
                            supplier = ""
                        }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                Text("הוסיף")
                            }
                        }
                    }
                    
                    // existing suppliers list
                    Section(header: Text("בחר ספק")) {
                        List(model.suppliersList) { supplier in
                            HStack {
                                HStack {
                                    Text(supplier.name)
                                    Spacer()
                                    Spacer()
                                }
                                if isAdding {
                                    // delete and edit buttons
                                    HStack {
                                        Button(action: {
                                            // edit name
                                            supplierToEdit = supplier.id
                                            showEditWindow = true
                                            // should change the name for all the items by this supplier
                                        }) {
                                            Image(systemName: "pencil")
                                        }
                                        // adding this restricts click to image not entire row
                                        .buttonStyle(PlainButtonStyle())
                                        .foregroundColor(Color(UIColor.systemBlue))
                                    }
                                    Spacer()
                                    Spacer()
                                    HStack {
                                        Button(action: {
                                            // delete
                                            supplierToDelete = supplier.id
                                            showDeleteWarning = true
                                            // what if already used by some items?
                                            
                                        }) {
                                            Image(systemName: "trash")
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                    }
                }
//                .onTapGesture {
//                    hideKeyboard()
//                }
                .navigationTitle("ספקים")
                // edit button in toolbar
                .toolbar {
                    ToolbarItem() {
                        if !isAdding {
                            Button("עריכה") {
                                isAdding = true
                            }
                        }
                        else {
                            Button ("סיום") {
                                isAdding = false
                            }
                        }
                    }
                }
                // delete alert
                .alert(isPresented: $showDeleteWarning) {
                            Alert(
                                title: Text("בטוח למחוק?"),
                                message: Text("לא ניתן לשחזר אחרי מחיקה"),
                                primaryButton: .destructive(Text("מחק")) {
                                    // delete
                                    model.deleteIden(collection: "Suppliers", id: supplierToDelete)
                                    supplierToDelete = ""
                                    showDeletedAlert = true
                                    // stop alert after 1 seconds
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        self.showDeletedAlert = false
                                    }
                                },
                                secondaryButton: .cancel(Text("ביטול"))
                            )
                        }
            }
            
            // show alert after successfully adding new supplier
            if showAddedAlert {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color(UIColor.systemGray5))
                    .frame(width: 150, height: 150)
                    .overlay(
                        VStack{
                            Image(systemName: "checkmark")
                            Text("בוצעה בהצלחה")
                        })
            }
            
            // show deleted successfully alert
            if showDeletedAlert {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color(UIColor.systemGray5))
                    .frame(width: 150, height: 150)
                    .overlay(
                        VStack{
                            Image(systemName: "xmark")
                            Text("נמחק בהצלחה")
                        })
            }
            
            // show edit text
            // edit popup window
            if showEditWindow {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.white)
                    .frame(width: 270, height: 170)
                    .cornerRadius(20).shadow(radius: 20)
                    .overlay(
                        VStack{
                            VStack {
                                Spacer()
                                Text("עדכון שם ספק")
                                    .bold()
                                Text(supplierToEdit)
                                    .fontWeight(.light)
                                HStack {
                                    Spacer()
                                    Spacer()
                                    Spacer()
                                    TextField("שם חדש", text: $supplierNew)
                                        .multilineTextAlignment(.center)
                                        .background(
                                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                                .stroke(.gray))
                                    Spacer()
                                    Spacer()
                                    Spacer()
                                }
                                Spacer()
                            }
                            Spacer()
                            Divider()
                                .padding(0)
                            HStack {
                                Spacer()
                                
                                Button("עדכן") {
                                    // look for all the items with this supplier and change to new name
                                    model.updateIden(collection: "Suppliers", field: "supplier", oldValue: supplierToEdit, newValue: supplierNew)
                                    // delete old supplier name and add new one (delete > add because id=name)
                                    model.deleteIden(collection: "Suppliers", id: supplierToEdit)
                                    model.addIden(collection: "Suppliers", name: supplierNew)
                                    showEditWindow = false
                                    showAddedAlert = true
                                    // stop alert after 1 second
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        self.showAddedAlert = false
                                    }
                                    //reset values
                                    supplierToEdit = ""
                                    supplierNew = ""
                                }
                                .padding()
                                .buttonStyle(PlainButtonStyle())
                                .foregroundColor(Color(UIColor.systemBlue))
                                .frame(height: 40)
                                
                                Spacer()
                                ExDivider()
                                Spacer()
                                
                                Button("ביטול") {
                                    showEditWindow = false
                                }
                                .padding()
                                .buttonStyle(PlainButtonStyle())
                                .foregroundColor(Color(UIColor.systemBlue))
                                .frame(height: 40)
                                
                                Spacer()
                            }
                            .padding(0)
                        })
            }
        }
    }
}

struct SuppliersView_Previews: PreviewProvider {
    static var previews: some View {
        SuppliersView()
    }
}

