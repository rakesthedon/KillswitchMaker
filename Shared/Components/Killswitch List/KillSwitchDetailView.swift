//
//  KillSwitchDetailView.swift
//  KillswitchMaker
//
//  Created by Yannick Jacques on 2022-05-10.
//

import SwiftUI

struct KillSwitchDetailView: View {
    
    let viewModel: KillswitchItemViewModel
    
    @State var thumbnailPresented: Bool = false
    
    @ViewBuilder
    var body: some View {
        Form {
            #if os(macOS)
            Text(viewModel.title)
                .font(.title)
            #endif
            thumbnailView
            
            Section("Identifier") {
                Text(viewModel.id)
            }
            
            Section("Body") {
                Text(viewModel.body)
            }
        }
        .sheet(isPresented: $thumbnailPresented) {
            AsyncImage(url: viewModel.thumbnailUrl) { phase in
                switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        EmptyView()
                    @unknown default:
                        EmptyView()
                }
            }
            .onTapGesture {
                thumbnailPresented.toggle()
            }
        }
        #if os(iOS)
        .navigationTitle(viewModel.title)
        #endif
    }
}

private extension KillSwitchDetailView {
    
    @ViewBuilder
    var thumbnailView: some View {
        if let thumbnailUrl = viewModel.thumbnailUrl {
            Button {
                thumbnailPresented.toggle()
            } label: {
                HStack(alignment: .center) {
                    Text("Thumbnail")
                    Spacer()
                    AsyncImage(url: thumbnailUrl) { phase in
                        switch phase {
                            case .empty:
                                ProgressView().frame(maxWidth: .infinity, alignment: .center)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            case .failure:
                                EmptyView()
                            @unknown default:
                                EmptyView()
                        }
                    }
                }
                .frame(height: 44, alignment: .center)
            }
        } else {
            EmptyView()
        }
    }
}
