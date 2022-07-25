//
//  ItemsListView.swift
//  NexusInv
//
//  Created by Elias Abunuwara on 2022-07-15.
//

import SwiftUI
import Firebase

struct ItemsListView: View {
    @EnvironmentObject var model: ViewModel
    @State var changeSettings = true
    
    var body: some View {
        NavigationView {
            VStack {
                if model.list.isEmpty {
                    Text("אין פריטים במלאי")
                }
                
                else {
                    NavigationLink(destination: ItemOptionsView(showOptions: $model.showItemOptions, changeSettings: $changeSettings).environmentObject(model), isActive: $model.showItemOptions) { EmptyView() }
                    Text("סה״כ במלאי: " + String(model.inventoryTotalAmount) + " ₪ ")
                    Form {
                        Section(header: Text("בחר פריט")) {
                            List(model.list) { item in
                                HStack {
                                    HStack {
                                        Text(item.nickname)
                                    }
                                    Spacer()
                                    HStack {
                                        Text("במלאי: " + String(item.stock))
                                            .foregroundColor(Color.gray)
                                        Button {
                                            model.getIden(collection: "Suppliers")
//                                            model.getIden(collection: "Brands")
                                            model.fetchItem(barcode: item.id, status: 1)
                                        } label: {
                                            Image(systemName: "pencil")
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .foregroundColor(Color(UIColor.systemBlue))
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("פריטים במלאי")
        }
    }
}

struct ItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsListView()
    }
}
