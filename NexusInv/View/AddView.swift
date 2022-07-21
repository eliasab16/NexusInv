//
//  AddView.swift
//  NexusInv
//
//  Created by Elias Abunuwara on 2022-07-15.
//

import Foundation
import SwiftUI

struct DismissingRegView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button("Dismiss Me") {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct AddView: View {
    @EnvironmentObject var model : ViewModel
    
    
    @State private var registerPressed = false
    
    @State var showingAddPage = false
    @State var brand = ""
    @State var type = ""
    @State var nickname = ""
    @State var stock = ""

    var body: some View {
        NavigationView {
                VStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                        Form {
                            Section(header: Text("REGISTER DETAILS")) {
                                TextField("Company/Brand", text: $brand)
                                TextField("Type", text: $type)
                                TextField("Nickname", text: $nickname)
                                // Will convert to Int when passing it to the function
                                TextField("Quantity", text: $stock)
                                    .keyboardType(.decimalPad)
                            }
                        }
                        .navigationBarTitle("Item not found")
                        .background(Color.white)
                        
                        Button(action: {

                            // Call add data
//                            model.addData(id: model.barcodeValue, brand: brand, type: type, stock: Int(stock) ?? 0, nickname: nickname)
                            
                            registerPressed = true

                            // Clear the text fields
                            brand = ""
                            type = ""
                            stock = "0"
                            nickname = ""
                        }, label: {
                            HStack {
                                Spacer()
                                Text("Register")
                                Spacer()
                            }
                        })
                            .padding(.horizontal, 25.0)
                            .padding(.vertical, 10.0)
                            .buttonStyle(RoundedRectangleButtonStyle())
                            .buttonStyle(BorderlessButtonStyle())
                            .buttonStyle(DefaultButtonStyle())
                }
    //                    .sheet(isPresented: $registerPressed) {
    //                                DismissingRegView()
    //                            }
                
    //            Text("Please enter the details below")
                
    //            VStack {
    //                TextField("Company/Brand", text: $brand)
    //                    .textFieldStyle(RoundedBorderTextFieldStyle())
    //                TextField("Type", text: $type)
    //                    .textFieldStyle(RoundedBorderTextFieldStyle())
    //                TextField("Nickname", text: $nickname)
    //                    .textFieldStyle(RoundedBorderTextFieldStyle())
    //                // Will convert to Int when passing it to the function
    //                TextField("Quantity", text: $stock)
    //                    .textFieldStyle(RoundedBorderTextFieldStyle())
    //                    .keyboardType(.decimalPad)
    //
                    
    //
    //            }
                
                
            }
        }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}

