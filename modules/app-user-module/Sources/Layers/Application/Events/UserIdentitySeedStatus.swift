public enum UserIdentitySeedStatus: String, Sendable, CaseIterable, Codable {
    case invited
    case active
    case suspended
    case deactivated
    case anonymized
}
