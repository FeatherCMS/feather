import FeatherContracts

struct WebMenuItemMoveFormInput: Decodable, Sendable {
    let beforeItemId: String?

    var normalizedBeforeItemID: String? {
        guard let beforeItemId else { return nil }
        let normalized = beforeItemId.whitespaceTrimmed
        return normalized.isEmpty ? nil : normalized
    }
}
