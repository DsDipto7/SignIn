import SwiftUI
import Firebase
import FirebaseAuth

struct ListView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showPopup = false
    @Binding var userIsLoggedIn: Bool

    var body: some View {
        NavigationView {
            ZStack {
                Color.teal.opacity(0.1).ignoresSafeArea()

                List(dataManager.dogs, id: \.id) { dog in
                    HStack {
                        Text(dog.breed)
                            .font(.title3)
                            .foregroundColor(.black)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                            .shadow(radius: 2)
                    }
                    .padding(.vertical, 5)
                }
                .navigationTitle("Dogs")
                .navigationBarItems(trailing: Button(action: {
                    showPopup.toggle()
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }))
                .navigationBarItems(trailing: Button(action: {
                    logout()
                }, label: {
                    Text("Logout")
                        .font(.title2)
                        .foregroundColor(.red)
                }))
                .sheet(isPresented: $showPopup) {
                    NewDogView()
                }
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            userIsLoggedIn = false
            print("User logged out successfully")
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(userIsLoggedIn: .constant(true)).environmentObject(DataManager())
    }
}
