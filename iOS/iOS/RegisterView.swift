//
//  RegisterView.swift
//  iOS
//
//  Created by James Wolfe on 16/07/2023.
//

import SwiftUI
import Logic

struct RegisterView: View {
    
    // MARK: - Variables
    @State var name = ""
    @FocusState var nameFocused: Bool
    @State var email = ""
    @FocusState var emailFocused: Bool
    @State var password = ""
    @FocusState var passwordFocused: Bool
    @State var confirmPassword = ""
    @FocusState var confirmPasswordFocused: Bool
    @State var state: UIState = .initial
    
    let authService = Logic(environment: .develop, token: { nil }).auth
    
    // MARK: - Actions
    func register() {
        withAnimation { state = .loading }
        Task {
            do {
                let token = try await authService.register(request: .init(name: name, email: email, password: password, confirmPassword: confirmPassword))
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
            TextField("Enter name", text: $name, prompt: .init("Name"))
                .textContentType(.name)
                .autocorrectionDisabled()
                .focused($nameFocused)
                #if os(iOS)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.words)
                .textFieldStyle(.roundedBorder)
                #endif
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
            SecureField("Enter password confirmation", text: $confirmPassword, prompt: .init("Confirm Password"))
                .textContentType(.password)
                .autocorrectionDisabled()
                .focused($confirmPasswordFocused)
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
            Button(action: register, label: {
                HStack {
                    Spacer()
                    if state == .loading {
                        ProgressView()
                            .foregroundColor(.white)
                    } else {
                        Text("Register")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .frame(height: 50)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 12.5))
            })
            .disabled(state == .loading || email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            .padding(.top)
        }
        .onChange(of: emailFocused, { _, newValue in
            guard newValue, state.isError else { return }
            withAnimation {
                state = .initial
            }
        })
        .onChange(of: nameFocused, { _, newValue in
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
        .onChange(of: confirmPasswordFocused, { _, newValue in
            guard newValue, state.isError else { return }
            withAnimation {
                state = .initial
            }
        })
        .onChange(of: state, { _, newValue in
            if newValue == .loading {
                emailFocused = false
                passwordFocused = false
                nameFocused = false
                confirmPasswordFocused = false
            }
        })
        .onAppear {
            nameFocused = true
        }
        .padding()
//        .navigationTitle("Register")
    }
}

#Preview {
    RegisterView()
}
