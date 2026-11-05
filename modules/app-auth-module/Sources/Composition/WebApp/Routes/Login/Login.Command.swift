extension Login {
    struct Command: Sendable {
        let email: String
        let password: String
        let isPersistent: Bool
    }
}
