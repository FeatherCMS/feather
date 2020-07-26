//
//  String+Replace.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 01. 25..
//

import Foundation

extension String {
    
    func replace(_ pattern: String,
                 options: NSRegularExpression.Options = [],
                 collector: ([String]) -> String) -> String
    {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return self
        }
        let matches = regex.matches(in: self,
                                    options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                    range: NSRange(self.startIndex..., in: self))
        guard matches.count > 0 else {
            return self
        }
        var splitStart = startIndex
        return matches.map { match -> (String, [String]) in
            let range = Range(match.range, in: self)!
            let split = String(self[splitStart ..< range.lowerBound])
            splitStart = range.upperBound
            return (split, (0 ..< match.numberOfRanges)
                .compactMap { Range(match.range(at: $0), in: self) }
                .map { String(self[$0]) }
            )
        }.reduce("") { "\($0)\($1.0)\(collector($1.1))" } + self[Range(matches.last!.range, in: self)!.upperBound ..< endIndex]
    }
    
    func replace(_ regexPattern: String,
                 options: NSRegularExpression.Options = [],
                 collector: @escaping () -> String) -> String
    {
        return self.replace(regexPattern, options: options) { _ in collector() }
    }
}
