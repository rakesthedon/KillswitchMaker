//
//  KillswitchViewModel.swift
//  KillswitchMaker
//
//  Created by Yannick Jacques on 2022-05-10.
//

import KillSwitchCoreKit
import Foundation

final class KillswitchItemViewModel {

    let id: String
    let title: String
    let body: String
    let thumbnailUrl: URL?

    init(id: String, title: String, body: String, thumbnailUrl: URL?) {
        self.id = id
        self.title = title
        self.body = body
        self.thumbnailUrl = thumbnailUrl
    }
    
    convenience init(id: String, killswitchPayload: KillswitchPayload) {
        let title = killswitchPayload.title
        let body = killswitchPayload.body
        let thumbnailUrl = killswitchPayload.thumbnailUrl
        
        self.init(id: id, title: title, body: body, thumbnailUrl: thumbnailUrl)
    }
}

extension KillswitchItemViewModel: Identifiable {}

final class KillswitchListViewModel: ObservableObject {
    
    @Published var isLoading: Bool = true
    @Published var itemViewModels: [KillswitchItemViewModel] = []

    private var killswitches: [String: KillswitchPayload] = [:]

    private let service = KillSwitchApiService()
    
    func loadKillSwitches() async {
        do {
            killswitches = try await service.fetchKillswitches()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.itemViewModels = self.killswitches.compactMap { KillswitchItemViewModel(id: $0.key, killswitchPayload: $0.value) }
            }
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func add(killswitch: KillswitchPayload, with id: String) {
        killswitches[id] = killswitch
        let itemViewModel = KillswitchItemViewModel(id: id, killswitchPayload: killswitch)
        
        itemViewModels.append(itemViewModel)
    }
}
