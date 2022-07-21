//
//  RegisterView.swift
//  NexusInv
//
//  Created by Elias Abunuwara on 2022-07-15.
//

import SwiftUI
import UIKit

struct RegisterView: View {
    // passing variable showReg from Scanner View - this variable indicates whether Register View should be displayed
    @EnvironmentObject var model : ViewModel
    
    @Binding var showReg: Bool
    
    // to add another field, declare below, add to the form, and add to ViewModel and ItemOptionsView
    @State var brand = ""
    @State var type = ""
    @State var stock = ""
    @State var recQuantity = ""
    @State var nickname = ""
    @State var supplier = ""
    @State var boxQuantity = ""
    
    @State var editDisable = true
    
    var body: some View {
        VStack {
            Form {
                HStack {
                    Text("פריט אינו קיים במלאי")
                }
                
                // section
                // item details
                Section(header: Text("הקלד פרטים")) {
                    // dropdown meny for brands
                    Picker(selection: $brand, label: Text("חברה")) {
                        ForEach(model.brandsList) { brand in
                            Text(brand.name)
                        }
                    }
                    
                    HStack {
                        Text("סוג פריט")
                        TextField("סוג פריט", text: $type)
                            .multilineTextAlignment(TextAlignment.trailing)
                    }
                    
                    HStack {
                        Text("כינוי")
                        TextField("כינוי", text: $nickname)
                            .multilineTextAlignment(TextAlignment.trailing)
                    }
                    
                    // dropdown meny for suppliers
                    Picker(selection: $supplier, label: Text("ספק")) {
                        ForEach(model.suppliersList) { supplier in
                            Text(supplier.name)
                        }
                    }
                    
                    HStack {
                        Text("כמות באריזה")
                        TextField("כמה יחידות מגיע באריזה", text: $boxQuantity)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(TextAlignment.trailing)
                    }
                    
                    HStack {
                        Text("כמות במלאי")
                        TextField("כמות במלאי", text: $stock)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(TextAlignment.trailing)
                    }
                    
//                    HStack {
//                        Text("כמות מומלצת")
//                        TextField("כמות מומלצת", text: $recQuantity)
//                            .keyboardType(.decimalPad)
//                            .multilineTextAlignment(TextAlignment.trailing)
//                    }
                }
                
                // section: button
                Section {
                    Button(action: {
                        
                        // Call add data
                        model.addData(id: model.barcodeValue, brand: brand, type: type, stock: Int(stock) ?? 0, nickname: nickname, supplier: supplier, recQuantity: Int(recQuantity) ?? 0, boxQuantity: Int(boxQuantity) ?? 1)
                        
                        // Clear the text fields
                        brand = ""
                        type = ""
                        stock = ""
                        nickname = ""
                        supplier = ""
                        recQuantity = ""
                        boxQuantity = ""
                        
                        // close down window - return to Scanner View
                        showReg = false
                    }, label: {
                        HStack {
                            Spacer()
                            Text("הוסיף")
                            Spacer()
                        }
                    })
                        .buttonStyle(PlainButtonStyle())
                        .foregroundColor(Color(UIColor.systemBlue))
                    // if any of the three entries (except nickname) is empty, disable button
                        .disabled(type.isEmpty || brand.isEmpty || stock.isEmpty)
                }
            }
            .navigationTitle("הוספת פריט למלאי")
            // hide the keyboard if user clicks outside the form
            //                .onTapGesture {
            //                    hideKeyboard()
            //                }
            .environment(\.layoutDirection, .rightToLeft)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RegisterView(showReg: .constant(true))
                .preferredColorScheme(.light)
        }
    }
}
