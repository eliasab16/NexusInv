//
//  AddProjectView.swift
//  NexusInv
//
//  Created by Elias Abunuwara on 2022-07-15.
//

import SwiftUI

struct AddProjectView: View {
    @EnvironmentObject var model: ViewModel
    @Binding var showAddProject: Bool
    
    @State var subProjectsList = [Project]()
    @State var projectName = ""
    @State var subProjectName = ""
    
    var body: some View {
        ZStack {
            Form {
                Section {
                    HStack {
                        Text("שם פרויקט")
                        TextField("הקלד שם", text: $projectName)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                // subproject section
                Section(header: Text("לוחות בפרויקט")) {
                    List(subProjectsList) { project in
                        Text(project.name)
                    }
                    HStack {
                        Text("שם לוח")
                        TextField("הקלד שם", text: $subProjectName)
                            .multilineTextAlignment(.trailing)
                        Spacer()
                        Button(action: {
                            subProjectsList.append(Project(name: subProjectName))
                            subProjectName = ""
                        }) {
                            Image(systemName: "plus.circle")
                        }
                        .disabled(subProjectName.isEmpty)
                    }
                }
                
                // add button section
                Section {
                    Button(action: {
                        // add the project and the lists
                        
                        
                        // close down window - return to Projects View
                        showAddProject = false
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
                        .disabled(projectName.isEmpty || subProjectName.isEmpty)
                }
                
                
            }
        }
        .navigationTitle("פרויקט חדש")
    }
}

struct AddProjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddProjectView(showAddProject: .constant(true))
    }
}
