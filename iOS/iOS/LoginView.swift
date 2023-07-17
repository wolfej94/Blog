//
//  LoginView.swift
//  iOS
//
//  Created by James Wolfe on 16/07/2023.
//

import SwiftUI
import Logic

struct LoginView: View {
    
    // MARK: - Variables
    @State var email = ""
    @FocusState var emailFocused: Bool
    @State var password = ""
    @FocusState var passwordFocused: Bool
    @State var state: UIState = .initial
    @EnvironmentObject var logic: Logic
    
    // MARK: - Actions
    func login() {
        withAnimation { state = .loading }
        Task {
            do {
                let token = try await logic.auth.login(email: email, password: password)
                await MainActor.run {
                    AuthObserver.shared.token = token
                }
            } catch {
                await MainActor.run {
                    withAnimation {
                        state = .error(message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // MARK: - Views
    var body: some View {
        VStack {
            Spacer()
            TextField("Enter email", text: $email, prompt: .init("Email"))
                .textContentType(.emailAddress)
                .autocorrectionDisabled()
                .focused($emailFocused)
                #if os(iOS)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                #endif
            SecureField("Enter password", text: $password, prompt: .init("Password"))
                .textContentType(.password)
                .autocorrectionDisabled()
                .focused($passwordFocused)
                #if os(iOS)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                #endif
            if case .error(let message) = state {
                HStack {
                    Text(message)
                        .foregroundColor(.red)
                        .font(.caption)
                    Spacer()
                }
            }
            Button(action: login, label: {
                HStack {
                    Spacer()
                    if state == .loading {
                        ProgressView()
                            .foregroundColor(.white)
                    } else {
                        Text("Log In")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .frame(height: 50)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 12.5))
            })
            .disabled(state == .loading || email.isEmpty || password.isEmpty)
            .padding(.top)
            NavigationLink(
                destination: {
                    RegisterView()
                        .environmentObject(logic)
                },
                label: {
                    Text("Register")
                        .font(.title3)
                        .foregroundColor(.accentColor)
                }
            )
            .padding(.top)
        }
        .onChange(of: emailFocused, { _, newValue in
            guard newValue, state.isError else { return }
            withAnimation {
                state = .initial
            }
        })
        .onChange(of: passwordFocused, { _, newValue in
            guard newValue, state.isError else { return }
            withAnimation {
                state = .initial
            }
        })
        .onChange(of: state, { _, newValue in
            emailFocused = newValue == .loading
            passwordFocused = newValue == .loading
        })
        .onAppear {
            emailFocused = true
        }
        .padding()
        .navigationTitle("Login")
    }
}

#Preview {
    LoginView()
        .environmentObject(
            Logic(
                environment: .develop,
                token: { AuthObserver.shared.token }
            )
        )
}
