//
//  KillSwitchApiService.swift
//  KillswitchMaker (iOS)
//
//  Created by Yannick Jacques on 2022-05-10.
//

import Foundation
import KillSwitchCoreKit

final class KillSwitchApiService {
    
    enum ApiError: Error {
        case invalidPayload
        case invalidURL
        case invalidResponse
    }
    
    func fetchKillswitches() async throws -> [String: KillswitchPayload] {
        guard let url = URL(string: "http://localhost:8080/killswitch") else {
            throw ApiError.invalidURL
        }

        let data = try await URLSession.shared.data(from: url).0

        return try JSONDecoder().decode([String: KillswitchPayload].self, from: data)
    }
    
    func createNewKillswitch(from payload: KillswitchPayload) async throws -> [String: KillswitchPayload] {
        guard !payload.title.isEmpty, !payload.body.isEmpty else { throw ApiError.invalidPayload }
        guard let url = URL(string: "http://localhost:8080/killswitch") else {
            throw ApiError.invalidURL
        }

        let data = try JSONEncoder().encode(payload)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let responseData = try await URLSession.shared.data(for: request).0

        guard
            let jsonObject = try JSONSerialization.jsonObject(with: responseData) as? [String: Any],
            let id = jsonObject["id"] as? String
        else { throw ApiError.invalidResponse }
        
        let killswitchPayload = try JSONDecoder().decode(KillswitchPayload.self, from: responseData)
        
        return [id: killswitchPayload]
    }
}
