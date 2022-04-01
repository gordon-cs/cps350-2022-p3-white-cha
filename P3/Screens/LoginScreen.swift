import SwiftUI
import Firebase


struct LoginScreen: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    @State var dpPath = ""
    
    init() {
        FirebaseApp.configure()
    }
    
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    private func handleAccount() {
        if isLoginMode {
            print("Log into Firebase w/ email \(email) & password \(password)")
        } else {
            createAcc()
            print("Register new Firebase account w/ email \(email) & password \(password) & image")
        }
    }
    
    private func createAcc() {
        Auth.auth().createUser(withEmail: email, password: password) {
            result, e in
            if let e = e {
                print("Failed to create user:", e)
                return
            }
            
            print("created user: \(result?.user.uid ?? "" ) ")
        }
            
        
    }
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
