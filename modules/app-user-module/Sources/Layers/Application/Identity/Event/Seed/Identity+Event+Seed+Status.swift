public import UserModule

extension Identity.Event.Seed {
    public enum Status: String, Sendable, CaseIterable, Codable {
        case invited
        case active
        case suspended
        case deactivated
        case anonymized
    }
}
