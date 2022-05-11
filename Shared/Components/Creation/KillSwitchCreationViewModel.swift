//
//  KillSwitchCreationViewModel.swift
//  KillswitchMaker
//
//  Created by Yannick Jacques on 2022-05-10.
//

import Foundation
import KillSwitchCoreKit

final class KillSwitchCreationViewModel: ObservableObject {
    
    @Published var title: String
    @Published var body: String
    @Published var thumbnailUrlString: String
    
    @Published var primaryActionTitle: String = "Update Now"
    @Published var primaryActionUrl: String = "https://apps.apple.com/us/app/shopify-your-ecommerce-store/id371294472"
    @Published var primaryActionDismissOnClick: Bool = false
    
    @Published var secondaryActionTitle: String = "I'll Do That Later"
    @Published var secondaryActionUrl: String = ""
    @Published var secondaryActionDismissOnClick: Bool = true
    
    @Published var isSubmitting: Bool = false
    
    private let service = KillSwitchApiService()
    
    static var defaultBody: String {
        """
        Dear Merchant,
        In our continuous effort to provide you the best tools possible to run your business, we are sometime force to make some changes that might disturb your experience. In order for you to keep having the great experience you're used to we strongly suggest that you update your app.
        
        Thanks and keep doing what you do best!
        
        The Shopify team.
        """
    }
    
    init(title: String = "Application Update Required", body: String = KillSwitchCreationViewModel.defaultBody, thumbnailUrlString: String = "https://unsplash.com/photos/g1Kr4Ozfoac/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8MTJ8fGJ1c2luZXNzfGVufDB8fHx8MTY1MjI5ODA3Ng&force=true&w=640") {
        self.title = title
        self.body = body
        self.thumbnailUrlString = thumbnailUrlString
    }
    
    func submit() async throws -> [String: KillswitchPayload] {
        
        let primaryAction = KillswitchAction(primaryActionTitle.trimmingCharacters(in: .whitespaces).isEmpty ? nil : primaryActionTitle, url: URL(primaryActionUrl), dismissOnClick: primaryActionDismissOnClick)
        let secondaryAction = KillswitchAction(secondaryActionTitle.trimmingCharacters(in: .whitespaces).isEmpty ? nil : secondaryActionTitle, url: URL(secondaryActionUrl), dismissOnClick: secondaryActionDismissOnClick)
        let payload = KillswitchPayload(title: title, body: body, thumbnailUrl: URL(string: thumbnailUrlString), primaryAction: primaryAction, secondaryAction: secondaryAction, type: .default)
        
        return try await service.createNewKillswitch(from: payload)
    }
    
    func convertSecondaryActionToPrimaryAction() {
        primaryActionTitle = secondaryActionTitle
        primaryActionUrl = secondaryActionUrl
        primaryActionDismissOnClick = secondaryActionDismissOnClick
        
        resetSecondaryAction()
    }
    
    func resetSecondaryAction() {
        secondaryActionTitle = ""
        secondaryActionUrl = ""
        secondaryActionDismissOnClick = false
    }
    
    func resetPrimaryAction() {
        primaryActionTitle = ""
        primaryActionUrl = ""
        primaryActionDismissOnClick = false
    }
    
    func resetActions() {
        resetPrimaryAction()
        resetSecondaryAction()
    }
}
