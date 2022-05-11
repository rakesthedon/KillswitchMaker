//
//  KillSwitchCreationView.swift
//  KillswitchMaker
//
//  Created by Yannick Jacques on 2022-05-10.
//

import SwiftUI
import KillSwitchCoreKit

struct KillSwitchCreationView: View {
    
    typealias KillswitchSubmissCompletion = ([String: KillswitchPayload]) -> Void
    typealias KillswitchCreationCancelation = () -> Void
    
    @ObservedObject var viewModel: KillSwitchCreationViewModel
    
    @State var showThumbnailUI: Bool = false
    @State var showPrimaryAction: Bool = false
    @State var showSecondaryAction: Bool = false
    
    let onSubmit: KillswitchSubmissCompletion?
    let onCancel: KillswitchCreationCancelation?
    
    init(viewModel: KillSwitchCreationViewModel = .init(), onSubmit: KillswitchSubmissCompletion?, onCancel: KillswitchCreationCancelation?) {
        self.viewModel = viewModel
        self.onSubmit = onSubmit
        self.onCancel = onCancel
    }
    
    @ViewBuilder
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    onCancel?()
                } label: {
                    Text("Cancel")
                }
                .foregroundColor(.red)
                .offset(x: -16 , y: 0)
            }
            formView
        }
    }
}

private extension KillSwitchCreationView {
    var formView: some View {
        Form {
            TextField("Title", text: $viewModel.title)
            
            Section("Thumbnail") {
                thumbnailView
            }
            Section("Body") {
                TextEditor(text: $viewModel.body)
            }
            
            actionView
            
            Button {
                Task {
                    guard let killswitchResponse = try? await viewModel.submit() else { return }
                    onSubmit?(killswitchResponse)
                    onCancel?()
                }
            } label: {
                Text("Submit")
            }
        }
    }
    
    @ViewBuilder
    var actionView: some View {
        if showPrimaryAction {
            Section("Primary Action") {
                TextField("Title", text: $viewModel.primaryActionTitle)
                HStack {
                    
                    TextField("Url", text: $viewModel.primaryActionUrl)
                    if let url = URL(string: viewModel.primaryActionUrl) {
                        Link("Open", destination: url)
                    }
                }
                Toggle("Dismiss on click", isOn: $viewModel.primaryActionDismissOnClick)
            }
            
            if showSecondaryAction {
                Section("Secondary Action") {
                    TextField("Title", text: $viewModel.secondaryActionTitle)
                    HStack {
                        
                        TextField("Url", text: $viewModel.secondaryActionUrl)
                        if let url = URL(string: viewModel.secondaryActionUrl) {
                            Link("Open", destination: url)
                        }
                    }
                    Toggle("Dismiss on click", isOn: $viewModel.secondaryActionDismissOnClick)
                }
            } else {
                Section("Secondary Action") {
                    Button("Add Action") {
                        withAnimation { showSecondaryAction.toggle() }
                    }
                }
            }
        } else {
            Section("Primary Action") {
                Button("Add Action") {
                    withAnimation { showPrimaryAction.toggle() }
                }
            }
        }
    }

    @ViewBuilder
    var thumbnailView: some View {
        if showThumbnailUI {
            VStack(alignment: .leading) {
                HStack {
                    TextField("Thumbnail Url", text: $viewModel.thumbnailUrlString)
                    Button {
                        withAnimation {
                            viewModel.thumbnailUrlString.removeAll()
                            showThumbnailUI.toggle()
                        }
                    } label: {
                        Image(systemName: "x.circle")
                    }
                }
                if let thumbnailUrl = URL(string: viewModel.thumbnailUrlString) {
                    Divider()
                    Text("Preview")
                    AsyncImage(url: thumbnailUrl) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200, alignment: .center)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
        } else {
            Button {
                showThumbnailUI.toggle()
            } label: {
                Text("Add Thumbnail")
            }
        }
    }
}
