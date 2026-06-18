import Foundation

struct AssetEditForm: Decodable {
    var title: String = ""
    var altText: String = ""

    var normalizedTitle: String? {
        let value = title.trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? nil : value
    }

    var normalizedAltText: String? {
        let value = altText.trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? nil : value
    }
}
