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
    
    @Binding
    var searchResults: [SearchResult]
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search for a restaurant", text: $search)
                    .autocorrectionDisabled()
                    .onSubmit {
                        Task {
                            searchResults = (try? await mapkitManager.search(with: search)) ?? []
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
            List {
                ForEach(mapkitManager.completions) { completion in
                    Button {
                        if !isSearching {
                            didTapOnCompletion(completion)
                        }
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(completion.title)
                                .font(.headline)
                                .fontDesign(.rounded)
                            Text(completion.subTitle)
                            if let url = completion.url {
                                Link(url.absoluteString, destination: url)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .offset(y: 16)
        .padding()
        .frame(alignment: .top)
        .border(.red)
        .onChange(of: search) { _, _ in
            mapkitManager.update(queryFragment: search)
        }
    }
    
    private func didTapOnCompletion(_ completion: SearchCompletions) {
        Task {
            isSearching = true
            if let singleLocation = try? await mapkitManager.search(with: "\(completion.title) \(completion.subTitle)").first {
                searchResults = [singleLocation]
                isSearching = false
            }
        }
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
    @State
    var searchResults: [SearchResult] = []
    
    return MapSheetView(searchResults: $searchResults)
        .environment(AuthManager())
}
