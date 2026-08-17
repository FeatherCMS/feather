import Foundation

struct WebMenuItemMoveFormInput: Decodable, Sendable {
    let beforeItemId: String?

    var normalizedBeforeItemID: String? {
        guard let beforeItemId else { return nil }
        let normalized = beforeItemId.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        return normalized.isEmpty ? nil : normalized
    }
}
