import SwiftUI



struct LoginScreen: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    
    
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                
                VStack(spacing: 16) {
                    
                    
                    //Selection tab
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                    
                    // Displays Profile Picture Selection if not LoginMode
                    if !isLoginMode {
                        Button {
                            
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size:64))
                                .padding()
                        }
                    }
                    
                    // Email & PW Textfield
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(12)
                        .background(Color.white)
                    
                    SecureField("Password", text: $password)
                        .padding(12)
                        .background(Color.white)
                    
                    
                    // Create Button
                    Button {
                        handleAccount()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Login" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                            Spacer()
                        }.background(Color.blue)
                    }
                }.padding()
                
                
            }
            //title
            .navigationTitle(isLoginMode ? "Login" : "Create Account")
            .background(Color(.init(white:0, alpha: 0.05))
                            .ignoresSafeArea())
        }
    }
    
    
    private func handleAccount() {
        if isLoginMode {
            print("Log into Firebase w/ email \(email) & password \(password)")
        } else {
            print("Register new Firebase account w/ email \(email) & password \(password) & image")
        }
    }
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
