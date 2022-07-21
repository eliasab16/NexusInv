//
//  SettingsView.swift
//  NexusInv
//
//  Created by Elias Abunuwara on 2022-07-15.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var model: ViewModel
    
    @State var showingCustomers = false
    @State var showingSuppliers = false
    @State var showingBrands = false
    @State var showingProjects = false
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SuppliersView().environmentObject(model), isActive: $showingSuppliers) { EmptyView() }
                
                NavigationLink(destination: CustomersView().environmentObject(model), isActive: $showingCustomers) { EmptyView() }
                
                NavigationLink(destination: BrandsView().environmentObject(model), isActive: $showingBrands) { EmptyView() }
                
                NavigationLink(destination: ProjectsView().environmentObject(model), isActive: $showingProjects) { EmptyView() }
                
                Form {
                    Section {
                        Button {
                            showingSuppliers = true
                        } label: {
                            HStack {
                                Text("ספקים")
                                Spacer()
                                Image(systemName: "chevron.left")
                            }
                        }
                        
                        Button {
                            showingCustomers = true
                        } label: {
                            HStack {
                                Text("לקוחות")
                                Spacer()
                                Image(systemName: "chevron.left")
                            }
                        }
                        
                        Button {
                            showingBrands = true
                        } label: {
                            HStack {
                                Text("חברות")
                                Spacer()
                                Image(systemName: "chevron.left")
                            }
                        }
                        
                        Button {
                            showingProjects = true
                        } label: {
                            HStack {
                                Text("פרויקטים")
                                Spacer()
                                Image(systemName: "chevron.left")
                            }
                        }
                    }
                }
                .navigationTitle("הגדרות")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
