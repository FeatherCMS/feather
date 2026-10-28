extension Login {
    struct Result: Sendable {
        let token: String
        let isPersistent: Bool
        let expiresAt: Double
    }
}
