//
//  URL+Extensions.swift
//  KillswitchMaker (iOS)
//
//  Created by Yannick Jacques on 2022-05-11.
//

import Foundation

extension URL {
    
    init?(_ string: String?) {
        guard let string = string else {
            return nil
        }
        
        self.init(string: string)
    }
}
