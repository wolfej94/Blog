//
//  MineView.swift
//  iOS
//
//  Created by James Wolfe on 16/07/2023.
//

import SwiftUI
import Logic

struct MineView: View {
    
    // MARK: - Variables
    @State var state: UIState = .initial
    @State var items: [PostResponse] = []
    @EnvironmentObject var logic: Logic
    
    // MARK: - Views
    var body: some View {
        List
    }
}

#Preview {
    MineView()
        .environmentObject(
            Logic(
                environment: .develop,
                token: { AuthObserver.shared.token }
            )
        )
}
