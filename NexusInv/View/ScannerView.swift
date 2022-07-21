//
//  ScannerView.swift
//  NexusInv
//
//  Created by Elias Abunuwara on 2022-07-15.
//

import SwiftUI

//  Created by narongrit kanhanoi on 7/1/2563 BE.
//  Copyright © 2563 narongrit kanhanoi. All rights reserved.
//

import SwiftUI
import CarBode
import AVFoundation
import XCTest

struct cameraFrame: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            
            path.addLines( [
                
                CGPoint(x: 0, y: height * 0.25),
                CGPoint(x: 0, y: 0),
                CGPoint(x:width * 0.25, y:0)
            ])
            
            path.addLines( [
                
                CGPoint(x: width * 0.75, y: 0),
                CGPoint(x: width, y: 0),
                CGPoint(x:width, y:height * 0.25)
            ])
            
            path.addLines( [
                
                CGPoint(x: width, y: height * 0.75),
                CGPoint(x: width, y: height),
                CGPoint(x:width * 0.75, y: height)
            ])
            
            path.addLines( [
                
                CGPoint(x:width * 0.25, y: height),
                CGPoint(x:0, y: height),
                CGPoint(x:0, y:height * 0.75)
                
            ])
            
        }
    }
}

// extension to make ! work with Binding<Bool>
prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}

struct ScannerView: View {
    @EnvironmentObject var model : ViewModel
    
    // used to keep the pop up functionality at the end
    @State var nothing = false
    
    // Show add page
    @State var showingAddPage = false
    // To change view when a barcode is successfully scanned
    @State private var showOptions = false
    
    @State var barcodeValue = ""
    @State var torchIsOn = false
    @State var showingAlert = false
    @State var cameraPosition = AVCaptureDevice.Position.back
    
    @State var enableButton = false
//    @State private var isAuto = true
//    @State private var isAdding = true
    
    @State var customer = "בחר לקוח"
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("lightgrey-iphone")
                    .resizable()
                    .ignoresSafeArea()
                
                
                VStack {
                    NavigationLink(destination: RegisterView(showReg: $model.showRegister).environmentObject(model), isActive: $model.showRegister) { EmptyView() }
                    
                    NavigationLink(destination: ItemOptionsView(showOptions: $model.showItemOptions, changeSettings: .constant(false)).environmentObject(model), isActive: $model.showItemOptions) { EmptyView() }
                    
//                    HStack {
//                        Menu("פרויקטים") {
//                            Menu("project 1") {
//                                Text("p1.1")
//                                Text("p1.2")
//                            }
//                            Menu("project 2") {
//                                Text("p2.1")
//                                Text("p2.2")
//                                Text("p3.2")
//                            }
//                            Text("project 3")
//                        }
//                        Image(systemName: "chevron.up.chevron.down")
//                    }
//                    .font(.system(size: 18, weight: .semibold))
//                    .foregroundColor(.black)
//                                        .frame(width: 290, height: 35)
//                                        .background(
//                                            RoundedRectangle(cornerRadius: 8, style: .continuous)
//                                                .foregroundColor(.white))
//                    Form {
//                        Menu {
//                            Menu("פרויקט 1") {
//                                Text("p1.1")
//                                Text("p1.2")
//                            }
//                            Menu("project 2") {
//                                Text("p2.1")
//                                Text("p2.2")
//                                Text("p3.2")
//                            }
//                            Text("project 3")
//                        } label: {
//                            HStack {
//                                Text("פרויקטים")
//                                    .foregroundColor(.black)
//                                Spacer()
//                                Spacer()
//                                Text("פרויקט1")
//                                    .foregroundColor(.gray)
//                                Image(systemName: "chevron.up.chevron.down")
//                                    .foregroundColor(Color(UIColor.systemBlue))
//                            }
//                            .padding()
//                        }
//                        .font(.system(size: 18))
//                        .foregroundColor(.black)
//                                            .frame(width: 350, height: 50)
//                                            .background(
//                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
//                                                    .foregroundColor(.white))
                    //                        .font(.system(size: 18))
//                        .foregroundColor(.black)
//                                            .frame(width: 350, height: 50)
//                                            .background(
//                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
//                                                    .foregroundColor(.white))
//                    Spacer()
                    
                    // Scanner parameters
                    CBScanner(
                        supportBarcode: .constant([.code128, .code39, .upce, .ean13, .qr]),
                        torchLightIsOn: $torchIsOn,
                        scanInterval: .constant(1.0),
                        cameraPosition: $cameraPosition,
                        mockBarCode: .constant(BarcodeData(value:"My Test Data", type: .qr))
                    ){
                        barcodeValue = $0.value
                        // fetch items to display before pressing any buttons
                        model.fetchItemForDisplay(barcode: barcodeValue)
                        enableButton = true
                        // stop alert after 1 second
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.enableButton = false
                        }
                    }
                onDraw: {
                    print("Preview View Size = \($0.cameraPreviewView.bounds)")
                    print("Barcode Corners = \($0.corners)")
                    
                    let lineColor = UIColor.green
                    let fillColor = UIColor(red: 0, green: 1, blue: 0.2, alpha: 0.4)
                    //Draw Barcode corner
                    $0.draw(lineWidth: 1, lineColor: lineColor, fillColor: fillColor)
                    
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 280, maxHeight: 300, alignment: .topLeading)
                        .overlay(
                            VStack {
                                ZStack {
                                    cameraFrame()
                                        .stroke(lineWidth: 5)
                                        .frame(width: 500, height: 220)
                                        .foregroundColor(.blue)
                                    
                                    if model.itemFoundForDisplay {
                                        VStack {
                                            Text(model.brand)
                                                .foregroundColor(.blue)
                                                .shadow(color: .white, radius: 1)
                                            Text(model.nickname)
                                                .foregroundColor(.blue)
                                                .shadow(color: .white, radius: 1)
                                            Text("("+String(model.stock)+")")
                                                .foregroundColor(.blue)
                                                .shadow(color: .white, radius: 1)
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        )
                    Spacer()
                    // scanning options
                    HStack {
                        VStack {
                            HStack {
                                Text("מצב סריקה:")
                                    .foregroundColor(Color(UIColor.systemGray3))
                                HStack {
                                    Spacer()
                                    Spacer()
                                    if model.isAuto {
                                        Text("**אוטומטי**")
                                    }
                                    else {
                                        Text("**ידני**")
                                    }
                                    Toggle("", isOn: $model.isAuto)
                                }
                            }
                            .padding()
                            
                            HStack {
                                Text("פעולה:")
                                    .foregroundColor(Color(UIColor.systemGray3))
                                HStack {
                                    Spacer()
                                    Spacer()
                                    if model.isAdding {
                                        Text("**הוספה למלאי**")
                                    }
                                    else {
                                        Text("**הוצאה מהמלאי**")
                                    }
                                    Toggle("", isOn: $model.isAdding)
                                        .disabled(!model.isAuto)
                                }
                            }
                            .padding()
                            
                            HStack {
                                Text("במה מדובר?")
                                    .foregroundColor(Color(UIColor.systemGray4))
                                HStack {
                                    Spacer()
                                    Spacer()
                                    if model.isBox {
                                        Text("**באריזה**")
                                    }
                                    else {
                                        Text("**ביחידה**")
                                    }
                                    Toggle("", isOn: $model.isBox)
                                        .disabled(!model.isAuto)
                                }
                            }
                            .padding()
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.blue, lineWidth: 2)
                        )
                    }
                    .padding([.leading, .trailing])

                    
                    // scan button
                    VStack {
                        Button {
                            if enableButton {
                                // play sound
                                AudioServicesPlaySystemSound(1256)
                                // try to fetch the item using the barcode, this function determins which View to open next: RegisterView or ItemOptionsView
                                model.fetchItem(barcode: String(barcodeValue), status: 0)
                                
                                // turn off flashlight after scanning, before moving to a new view
                                if (self.torchIsOn == true) {
                                    self.torchIsOn.toggle()
                                }
                                enableButton = false
                            }
                        } label: {
                            Text("סרוק")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 200, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .foregroundColor(.blue))
                        }
                        
                    }
                    Spacer()
                    
                    // other options
                    HStack {
                        // flip camera button
                        Button(action: {
                            if cameraPosition == .back {
                                cameraPosition = .front
                            }else{
                                cameraPosition = .back
                            }
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(width: 40.0, height: 40.0)
                        .padding(.leading, 25.0)
                        
                        Spacer()
                        
                        // flashlight toggle button
                        Button(action: {
                            self.torchIsOn.toggle()
                        }) {
                            Image(systemName: torchIsOn ? "flashlight.on.fill" : "flashlight.off.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .frame(width: 40.0, height: 40)
                        .padding(.trailing, 25.0)
                    }
                }
                .alert(isPresented: $nothing) {
                    Alert(title: Text("Found Barcode"), message: Text("\(barcodeValue)"), dismissButton: .default(Text("Close")))
                }
            }
        }
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}

