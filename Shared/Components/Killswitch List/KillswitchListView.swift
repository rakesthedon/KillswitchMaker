//
//  ContentView.swift
//  Shared
//
//  Created by Yannick Jacques on 2022-05-10.
//

import SwiftUI
import KillSwitchCoreKit

struct KillswitchListView: View {
    
    @ObservedObject private var viewModel: KillswitchListViewModel
    
    init(viewModel: KillswitchListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
    #if os(macOS)
        contentView
            .frame(minWidth: 600, minHeight: 800, alignment: .topLeading)
    #elseif os(iOS)
        contentView
    #endif
        
    }
}

private extension KillswitchListView {
    
    @ViewBuilder
    var contentView: some View {
        if viewModel.isLoading {
            ProgressView().task {
                await viewModel.loadKillSwitches()
                viewModel.isLoading = false
            }
        } else {
            NavigationView {
                listView
            }
        }
    }
    
    var listView: some View {
        List(viewModel.itemViewModels) { itemViewModel in
            NavigationLink {
                KillSwitchDetailView(viewModel: itemViewModel)
            } label: {
                VStack(alignment: .leading) {
                    HStack(alignment: .lastTextBaseline) {
                        Text(itemViewModel.title)
                            .font(.headline)
                        Spacer()
                        Text(String(itemViewModel.id.prefix(6)))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Text(itemViewModel.body)
                        .font(.caption)
                        .lineLimit(3)
                }
            }
        }
    }
}
