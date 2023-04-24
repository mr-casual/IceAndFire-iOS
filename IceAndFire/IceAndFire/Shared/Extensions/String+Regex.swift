//
//  String+Regex.swift
//  IceAndFire
//
//  Created by Martin Klöpfel on 22.04.23.
//

import Foundation

public extension String {
    func matches(regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func matchGroups(regex: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: regex) else { return [] }
        guard let result = regex.firstMatch(in: self, range: NSRange(self.startIndex..., in: self))  else { return [] }
        var groups = [String]()
        for i in 0..<result.numberOfRanges where i > 0 {
            if let range = Range(result.range(at: i), in: self) {
                groups.append(String(self[range]))
            }
        }
        return groups
    }
}
