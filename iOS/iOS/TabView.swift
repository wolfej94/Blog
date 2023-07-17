//
//  MainView.swift
//  iOS
//
//  Created by James Wolfe on 16/07/2023.
//

import SwiftUI
import Logic

struct MainView: View {
    
    // MARK: - Variables
    @State var tab: Tab = .feed
    @EnvironmentObject var logic: Logic
    
    // MARK: - Views
    var body: some View {
        TabView(selection: $tab,
                content:  {
            ForEach(Tab.allCases) {
                $0.view
                    .environmentObject(logic)
            }
        })
    }
}

extension MainView {
     
    enum Tab: Equatable, Comparable, CaseIterable, Identifiable {
        
        // MARK: - Cases
        case feed
        case mine
        
        // MARK: - Variables
        var id: Int {
            switch self {
            case .feed:
                return 1
            case .mine:
                return 2
            }
        }
        
        var title: String {
            switch self {
            case .feed:
                return "Feed"
            case .mine:
                return "Mine"
            }
        }
        
        var icon: Image {
            switch self {
            case .feed:
                return Image(systemName: "newspaper")
            case .mine:
                return Image(systemName: "briefcase")
            }
        }
        
        @ViewBuilder var tabItem: some View {
            VStack {
                icon
                Text(title)
            }
        }
        
        @ViewBuilder var view: some View {
            switch self {
            case .feed:
                FeedView()
                    .tabItem { tabItem }
                    .tag(Tab.feed)
            case .mine:
                MineView()
                    .tabItem { tabItem }
                    .tag(Tab.mine)
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(
            Logic(
                environment: .develop,
                token: { AuthObserver.shared.token }
            )
        )
}
