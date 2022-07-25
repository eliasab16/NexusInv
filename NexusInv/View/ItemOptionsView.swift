//
//  ItemOptionsView.swift
//  NexusInv
//
//  Created by Elias Abunuwara on 2022-07-15.
//

import SwiftUI

struct ItemOptionsView: View {
    @EnvironmentObject var model: ViewModel
    
    // Binding variable for showing this view
    @Binding var showOptions: Bool
    @Binding var changeSettings: Bool
    
    @State var quantity = ""
    @State var brand = ""
    @State var type = ""
    @State var nickname = ""
    @State var supplier = ""
    @State var recQuantity = ""
    @State var editQuantity = ""
    @State var boxQuantity = ""
    @State var costPrice = ""
    @State var placeHolder = ""
    
    @State var editDisabled = true
    @State var showEditBtn = true
    @State var showingDeleteAlert = false
    @State var showAddedToInvAlert = false
    @State var showRemovedFromInvAlert = false
    @State private var isOn = true
    //@FocusState var isInputActive: Bool
    enum FocusField: Hashable {
        case field
    }
    
    @FocusState private var focusedField: FocusField?
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                if !changeSettings {
                    HStack {
                        Spacer()
                        VStack {
                            HStack {
                                Text(model.brand)
                                    .font(.system(size: 30.0))
                            }
                            HStack {
                                Text(model.nickname)
                                    .font(.system(size: 25.0))
                            }
                            HStack {
                                Text("כמות במלאי: ")
                                    .font(.system(size: 25.0))
                                Text(String(model.stock))
                                    .font(.system(size: 30.0))
                            }
                        }
                        Spacer()
                    }
                }
                
                Form {
                    // section
                    // list all item details
                    if changeSettings {
                        Section(header: Text("פרטים")) {
                            // dropdown meny for suppliers
                            if editDisabled {
                                HStack {
                                    Text("חברה (יצרן)")
                                    Spacer()
                                    Text(String(model.brand))
                                        .foregroundColor(Color(UIColor.systemGray4))
                                }
                            }
                            else {
                                // important: poopulate the brand variable wth model.brand to show on the picker
                                Picker(selection: $brand, label: Text("חברה (יצרן)")) {
                                    ForEach(model.brandsList) { brand in
                                        Text(brand.name)
                                    }
                                }
                            }
                            
                            HStack {
                                Text("סוג")
                                TextField(String(model.type), text: $type)
                                    .foregroundColor(Color.gray)
                                    .disabled(editDisabled)
                                    .multilineTextAlignment(TextAlignment.trailing)
                                
                                if !editDisabled {
                                    Image(systemName: "arrow.right")
                                }
                            }
                            
                            HStack {
                                Text("כינוי")
                                TextField(String(model.nickname), text: $nickname)
                                    .foregroundColor(Color.gray)
                                    .disabled(editDisabled)
                                    .multilineTextAlignment(TextAlignment.trailing)
                                
                                if !editDisabled {
                                    Image(systemName: "arrow.right")
                                }
                            }
                            
                            // dropdown meny for suppliers
                            if editDisabled {
                                HStack {
                                    Text("ספק")
                                    Spacer()
                                    Text(String(model.supplier))
                                        .foregroundColor(Color(UIColor.systemGray4))
                                }
                            }
                            else {
                                Picker(selection: $supplier, label: Text("ספק")) {
                                    ForEach(model.suppliersList) { supplier in
                                        Text(supplier.name)
                                    }
                                }
                            }
                            
                            HStack {
                                Text("כמות במלאי")
                                TextField(String(model.stock), text: $quantity)
                                    .keyboardType(.numberPad)
                                    .foregroundColor(Color.gray)
                                    .disabled(editDisabled)
                                    .multilineTextAlignment(TextAlignment.trailing)
                                
                                if !editDisabled {
                                    Image(systemName: "arrow.right")
                                }
                            }
                            
                            HStack {
                                Text("מחיר קניה ליחידה")
                                TextField(String(model.costPrice) + " ₪", text: $costPrice)
                                    .keyboardType(.numberPad)
                                    .foregroundColor(Color.gray)
                                    .disabled(editDisabled)
                                    .multilineTextAlignment(TextAlignment.trailing)
                                
                                if !editDisabled {
                                    Image(systemName: "arrow.right")
                                }
                            }
                            
                            if editDisabled {
                                HStack {
                                    Text("סה״כ במלאי")
                                    TextField(String(model.costPrice * model.stock) + " ₪", text: $placeHolder)
                                        .keyboardType(.numberPad)
                                        .foregroundColor(Color.gray)
                                        .disabled(true)
                                        .multilineTextAlignment(TextAlignment.trailing)
                                    
                                    if !editDisabled {
                                        Image(systemName: "arrow.right")
                                    }
                                }
                            }
                            
                            //                        HStack {
                            //                            Text("כמות מומלצת")
                            //                            TextField(String(model.recQuantity), text: $recQuantity)
                            //                                .foregroundColor(Color.gray)
                            //                                .disabled(editDisabled)
                            //                                .multilineTextAlignment(TextAlignment.trailing)
                            //
                            //                            if !editDisabled {
                            //                                Image(systemName: "arrow.right")
                            //                            }
                            //                        }
                            
                            // edit information and done buttons - alternate between the two button
                            HStack {
                                if editDisabled {
                                    Button(action: {
                                        // updating supplier and brand for the picker
                                        supplier = model.supplier
                                        brand = model.brand
                                        editDisabled = false
                                    }) {
                                        Image(systemName: "pencil")
                                        Text("ערוך פרטים")
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .foregroundColor(Color(UIColor.systemBlue))
                                }
                                else {
                                    Button(action: {
                                        // showEditBtn = true
                                        self.model.updateData(id: model.barcodeValue,
                                                              brand: brand.isEmpty ? model.brand : brand,
                                                              type: type.isEmpty ? model.type : type,
                                                              nickname: nickname.isEmpty ? model.nickname: nickname,
                                                              supplier: supplier.isEmpty ? model.supplier : supplier,
                                                              quantity: (quantity.isEmpty ? model.stock : Int(quantity)) ?? model.stock,
                                                              recQuantity: (recQuantity.isEmpty ? model.recQuantity : Int(recQuantity)) ?? model.recQuantity,
                                                              boxQuantity: Int(boxQuantity) ?? model.boxQuantity,
                                                              costPrice: (costPrice.isEmpty ? model.costPrice : Int(costPrice)) ?? model.costPrice)
                                        editDisabled = true
                                    }) {
                                        Image(systemName: "checkmark")
                                        Text("סיום")
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .foregroundColor(Color(UIColor.systemBlue))
                                }
                            }
                        }
                    }
                    // section
                    // Pick quantity
                    Section(header: Text("מספר פריטים לפעולה")) {
                        HStack {
                            Text("במה מדובר?")
                                .foregroundColor(Color(UIColor.systemGray4))
                            HStack {
                                Spacer()
                                Spacer()
                                if self.isOn {
                                    Text("**באריזה**")
                                }
                                else {
                                    Text("**ביחידה**")
                                }
                                Toggle("", isOn: $isOn)
                            }
                        }
                        TextField(self.isOn ? "כמה אריזות?" : "כמה יחידות?", text: $editQuantity)
                        //                            .focused($focusedField, equals: .field)
                            .focused($isFocused)
                            .onAppear {
                                // adding delay because of a bug: the keyboard focus won't work unless you add some delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                    //                                    self.focusedField = .field
                                    isFocused = true
                                }
                            }
                            .keyboardType(.numberPad)
                            .toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    HStack {
                                        Button("Done") {
                                            isFocused = false
                                        }
                                        Spacer()
                                    }
                                }
                                
                            }
                    }
                    
                    // section
                    // Pick action
                    Section(header: Text("פעולה")) {
                        // Button to add into inventory
                        Button(action: {
//                            model.updateQuantity(id: model.barcodeValue, quantity: self.isOn ? (Int(editQuantity) ?? 0) * (Int(boxQuantity) ?? 0) : Int(editQuantity) ?? 0)
                            model.updateQuantity(id: model.barcodeValue, quantity: self.isOn ? model.boxQuantity * (Int(editQuantity) ?? 0) : Int(editQuantity) ?? 0)
                            showAddedToInvAlert = true
                            // stop alert after 1 second
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.showAddedToInvAlert = false
                            }
                            editQuantity = ""
                            // close current view and return to previous one
                            showOptions = false
                            
                        }) {
                            HStack {
                                Image(systemName: "tray.and.arrow.down.fill")
                                    .resizable()
                                    .frame(width: 22.0, height: 22.0)
                                Text("הוסיף למלאי")
                            }
                        }
                        .disabled(editQuantity.isEmpty)
                        .buttonStyle(PlainButtonStyle())
                        .foregroundColor(Color(UIColor.systemBlue))
                        
                        
                        // Button to check out from inventory
                        Button(action: {
                            model.updateQuantity(id: model.barcodeValue, quantity: self.isOn ? model.boxQuantity * (Int("-" + editQuantity) ?? 0) : Int("-" + editQuantity) ?? 0)
                            showRemovedFromInvAlert = true
                            // stop alert after 1 second
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.showRemovedFromInvAlert = false
                            }
                            editQuantity = ""
                            // close current view and return to previous one
                            showOptions = false
                        }) {
                            HStack {
                                Image(systemName: "tray.and.arrow.up.fill")
                                    .resizable()
                                    .frame(width: 22.0, height: 22.0)
                                Text("הוציא מהמלאי")
                            }
                        }
                        .disabled(editQuantity.isEmpty)
                        .buttonStyle(PlainButtonStyle())
                        .foregroundColor(Color(UIColor.systemBlue))
                    }
                    
                    // section
                    // delete item from inventory
                    Section {
                        HStack {
                            Button(action: {
                                // self.showingOutInv.toggle()
                                showingDeleteAlert = true
                            }) {
                                HStack {
                                    Spacer()
                                    Text("מחק")
                                    Spacer()
                                }
                                //                            .foregroundColor(Color(UIColor.systemBlue))
                            }
                            .buttonStyle(PlainButtonStyle())
                            .foregroundColor(Color(UIColor.systemRed))
                        }
                    }
                }
                // hide the keyboard if user clicks outside the form
                //            .onTapGesture {
                //                hideKeyboard()
                //            }
                .ignoresSafeArea()
                //                .navigationBarTitle("פרטים")
                .alert(isPresented: $showingDeleteAlert) {
                    Alert(
                        title: Text("בטוח למחוק?"),
                        message: Text("לא ניתן לשחזר אחרי מחיקה"),
                        primaryButton: .destructive(Text("מחק")) {
                            // delete
                            model.deleteData(id: model.barcodeValue)
                            // return to previous view
                            showOptions.toggle()
                        },
                        secondaryButton: .cancel(Text("ביטול"))
                    )
                }
                
            }
            .environment(\.layoutDirection, .rightToLeft)
            
            
            // show alert after successfully adding to the inventory
            if showAddedToInvAlert {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color(UIColor.systemGray5))
                    .frame(width: 150, height: 150)
                    .overlay(
                        VStack{
                            Image(systemName: "checkmark")
                            Text("נוסף בהצלחה")
                        })
            }
            
            // show alert after successfully adding to the inventory
            if showRemovedFromInvAlert {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color(UIColor.systemGray5))
                    .frame(width: 150, height: 150)
                    .overlay(
                        VStack{
                            Image(systemName: "checkmark")
                            Text("הוצא בהצלחה")
                        })
            }
        }
    }
}




