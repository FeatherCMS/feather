#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

extension StringProtocol {
    public var whitespaceTrimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String {
    public var slugified: String {
        var result = ""
        var needsSeparator = false

        for scalar in folding(
            options: .diacriticInsensitive,
            locale: .current
        )
        .lowercased()
        .unicodeScalars {
            let isLowercaseLetter = scalar.value >= 97 && scalar.value <= 122
            let isNumber = scalar.value >= 48 && scalar.value <= 57

            if isLowercaseLetter || isNumber {
                if needsSeparator, !result.isEmpty {
                    result.append("-")
                }
                result.append(String(scalar))
                needsSeparator = false
            }
            else if !result.isEmpty {
                needsSeparator = true
            }
        }

        return String(result.prefix(254))
    }
}
