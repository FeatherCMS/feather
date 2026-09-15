import Foundation

/// Server-side, one-time tokens used to protect browser form submissions.
public actor AdminNonceStore {
    public static let shared = AdminNonceStore()

    private struct Entry: Sendable {
        let sessionToken: String?
        let expiresAt: Date
    }

    private var entries: [String: Entry] = [:]
    private let lifetime: TimeInterval

    public init(lifetime: TimeInterval = 15 * 60) {
        self.lifetime = lifetime
    }

    public func issue(sessionToken: String?) -> String {
        purgeExpired()
        let token = UUID().uuidString
        entries[token] = Entry(
            sessionToken: sessionToken,
            expiresAt: Date().addingTimeInterval(lifetime)
        )
        return token
    }

    /// Validates and consumes a token. A token can only be accepted once.
    public func consume(_ token: String?, sessionToken: String?) -> Bool {
        purgeExpired()
        guard
            let token,
            let entry = entries[token],
            entry.sessionToken == sessionToken,
            entry.expiresAt > Date()
        else {
            return false
        }
        entries.removeValue(forKey: token)
        return true
    }

    private func purgeExpired() {
        let now = Date()
        entries = entries.filter { $0.value.expiresAt > now }
    }
}
