//
//  MapSheetView.swift
//  pins
//
//  Created by yuncoffee on 12/20/23.
//

import SwiftUI

struct MapSheetView: View {
    @Environment(AuthManager.self)
    var authManager
    @Environment(MapkitManager.self)
    var mapkitManager
    
    @State
    private var search: String = ""
    
    @State
    private var isSearching = false
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search for a restaurant", text: $search)
                    .autocorrectionDisabled()
                    .onSubmit {
                        Task {
//                            searchResults = (try? await mapkitManager.search(with: search)) ?? []
                        }
                    }
            }
            .modifier(TextFieldGrayBackgroundColor())
            //            Button {
            //                authManager.signOut()
            //            } label: {
            //                Text("로그아웃")
            //            }
            Spacer()
        }
        .offset(y: 16)
        .padding()
        .frame(alignment: .top)
        .border(.red)
    }
}

struct TextFieldGrayBackgroundColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.primary)
    }
}
#Preview {
    return MapSheetView()
        .environment(AuthManager())
}
