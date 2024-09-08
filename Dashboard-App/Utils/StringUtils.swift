//
//  StringUtils.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/8/24.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        guard !self.isEmpty else { return self }
        let firstLetter = self.prefix(1).uppercased()
        let remainingString = self.dropFirst()
        return firstLetter + remainingString
    }
}

