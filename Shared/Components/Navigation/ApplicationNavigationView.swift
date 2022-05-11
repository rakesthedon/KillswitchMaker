//
//  ApplicationNavigationView.swift
//  KillswitchMaker
//
//  Created by Yannick Jacques on 2022-05-10.
//

import SwiftUI

struct ApplicationNavigationView: View {

    @State var isCreating: Bool = false
    @ObservedObject var listViewModel = KillswitchListViewModel()
    
    @ViewBuilder
    var body: some View {
        if isCreating {
            KillSwitchCreationView(viewModel: .init(), onSubmit: {
                $0.forEach { key, payload in
                    listViewModel.add(killswitch: payload, with: key)
                }
            }, onCancel: {
                isCreating.toggle()
            })
        } else {
            ZStack(alignment: .bottomTrailing) {
                KillswitchListView(viewModel: listViewModel)
                creationButton
                    .offset(x: -64, y: -64)
            }
        }
    }
}

private extension ApplicationNavigationView {
    
    var creationButton: some View {
        Button {
            isCreating.toggle()
        } label: {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 24, height: 24, alignment: .center)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .clipShape(Circle())
        }
    }
}
