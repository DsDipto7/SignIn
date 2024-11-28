import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false
    @State private var isSignUpMode = true
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            if userIsLoggedIn {
                ListView(userIsLoggedIn: $userIsLoggedIn)
            } else {
                loginContent
            }
        }
    }

    var loginContent: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 25) {
                Text(isSignUpMode ? "Create Account" : "Login")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Email Address")
                        .foregroundColor(.white)
                        .font(.headline)
                    TextField("Enter your email", text: $email)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.2)))
                        .foregroundColor(.white)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(.horizontal)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Password")
                        .foregroundColor(.white)
                        .font(.headline)
                    SecureField("Enter your password", text: $password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.2)))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.body)
                        .padding(.top, 10)
                }

                Button(action: {
                    if isSignUpMode {
                        register()
                    } else {
                        login()
                    }
                }) {
                    Text(isSignUpMode ? "Sign Up" : "Sign In")
                        .bold()
                        .frame(width: 200, height: 50)
                        .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .top, endPoint: .bottom)))
                        .foregroundColor(.white)
                }
                .padding(.top)

                Button(action: {
                    isSignUpMode.toggle()
                }) {
                    Text(isSignUpMode ? "Already have an account? Log In" : "Don't have an account? Sign Up")
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(.top)
            }
            .frame(width: 350)
            .onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        userIsLoggedIn = true
                    }
                }
            }
        }
    }

    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                userIsLoggedIn = true
                errorMessage = ""
            }
        }
    }

    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                userIsLoggedIn = true
                errorMessage = ""
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
