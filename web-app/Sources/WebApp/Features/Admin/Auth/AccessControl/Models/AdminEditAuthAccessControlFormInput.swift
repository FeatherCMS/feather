import Foundation

struct AdminEditAuthAccessControlFormInput: Codable, Sendable {
    let pairs: [String]?
    let search: String?

    var selectedPairs: Set<String> {
        Set((pairs ?? []).filter { !$0.isEmpty })
    }
}
