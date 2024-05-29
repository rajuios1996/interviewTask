//
//  DetailEmpView.swift
//  SciflareTask
//
//  Created by Chandru on 28/05/24.
//

import SwiftUI

struct DetailEmpView: View {
    
    @ObservedObject  var viewModel: CRUDViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var updateBool: Bool
    @State var id: String
    @State var NameText: String
    @State var emailText: String
    @State var mobileText: String
    @State var genderText: String
    
    var body: some View {
        VStack{
            ScrollView(showsIndicators: false) {
                nameField
                emailField
                mobileField
                genderField
                submitButton
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var nameField: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Name")
                .foregroundColor(.white)
                .font(.title3)
                .bold()
                .padding(.bottom, 10)
            
            TextField(text: $NameText) {
                Text("Enter Your Name")
                    .foregroundColor(.white.opacity(0.5))
            }
            .keyboardType(.namePhonePad)
            .foregroundColor(.white)
            .font(.headline)
            .padding(.leading, 20)
            .frame(height: 50)
            .background(
                Color.gray.opacity(0.7)
                    .cornerRadius(10)
            )
        }
    }
    
    private var emailField: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Email")
                .foregroundColor(.white)
                .font(.title3)
                .bold()
                .padding([.top,.bottom], 10)
            
            TextField(text: $emailText) {
                Text("Enter Your Email")
                    .foregroundColor(.white.opacity(0.5))
            }
            .keyboardType(.emailAddress)
            .foregroundColor(.white)
            .font(.headline)
            .padding(.leading, 20)
            .frame(height: 50)
            .background(
                Color.gray.opacity(0.7)
                .cornerRadius(10)
            )
        }
    }
    
    private var mobileField: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Mobile")
                .foregroundColor(.white)
                .font(.title3)
                .bold()
                .padding([.top,.bottom], 10)
            
            TextField(text: $mobileText) {
                Text("Enter Your Mobile")
                    .foregroundColor(.white.opacity(0.5))
            }
            .keyboardType(.phonePad)
            .foregroundColor(.white)
            .font(.headline)
            .padding(.leading, 20)
            .frame(height: 50)
            .background(
                Color.gray.opacity(0.7)
                .cornerRadius(10)
            )
        }
        
    }
    
    private var genderField: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Gender")
                .foregroundColor(.white)
                .font(.title3)
                .bold()
                .padding([.top,.bottom], 10)
            
            TextField(text: $genderText) {
                Text("Enter Your Gender")
                    .foregroundColor(.white.opacity(0.5))
            }
            .keyboardType(.emailAddress)
            .foregroundColor(.white)
            .font(.headline)
            .padding(.leading, 20)
            .frame(height: 50)
            .background(
                Color.gray.opacity(0.7)
                .cornerRadius(10)
            )
        }
        
    }
    
    private var submitButton: some View {
        VStack {
            Button {
                Task{
                    if updateBool == true {
                        viewModel.updateData(id: id, name:NameText,
                                                   email:emailText,
                                                   mobile:mobileText,
                                                   gender:genderText)
                    }else{
                        viewModel.addData(name:NameText,
                                                    email:emailText,
                                                    mobile:mobileText,
                                                    gender:genderText)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text("Save".uppercased())
                    .foregroundColor(.black)
                    .font(.title2)
                    .bold()
                    .padding()
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.cornerRadius(10))
                    .padding(.top, 30)
            }

        }
    }
}

struct DetailEmpView_Previews: PreviewProvider {
    static var previews: some View {
        DetailEmpView(viewModel: CRUDViewModel(), updateBool: false, id: "", NameText: "", emailText: "", mobileText: "", genderText: "")
    }
}
