import Foundation

struct AdminEditAuthSettingsFormInput: Codable, Sendable, Equatable, Hashable {
    let language: String
    let timezone: String
    let pageSize: Int
}
