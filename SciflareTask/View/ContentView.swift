//
//  ContentView.swift
//  SciflareTask
//
//  Created by Chandru on 28/05/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject  var viewModel: CRUDViewModel = CRUDViewModel()
   
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.employees) { emp in
                    NavigationLink(value: emp) {
                        HStack {
                            Text(emp.name ?? "")
                                .font(.headline)
                                .foregroundStyle(Color.white)
                        }
                    }
                }
                .onDelete { index in
                    viewModel.deleteData(indexSet:index)
                }
            }
            .navigationDestination(for: Employee
                .self) { emp in
                    DetailEmpView(viewModel: viewModel,
                                  updateBool: true,
                                  id: emp.id ?? "",
                                  NameText: emp.name ?? "",
                                  emailText: emp.email ?? "",
                                  mobileText: emp.mobile ?? "",
                                  genderText: emp.gender ?? "")
                }
                .onAppear(perform: {
                    viewModel.loadData()
                })
            
                .navigationTitle("Employees")
                .toolbar {
                    HStack {
                        NavigationLink {
                            DetailEmpView(viewModel: viewModel,
                                          updateBool: false,
                                          id: "",
                                          NameText: "",
                                          emailText: "",
                                          mobileText: "",
                                          genderText: "")
                            .environmentObject(viewModel)
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(Color.white)
                                .font(.headline)
                        }
                        Spacer()
                        NavigationLink {
                            MapView()
                        } label: {
                            Image(systemName: "location.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(Color.white)
                                .font(.headline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding([.leading], 20)
                }
        }
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
