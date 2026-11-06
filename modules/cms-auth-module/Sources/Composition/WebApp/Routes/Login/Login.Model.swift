extension Login {
    struct Model: Sendable {
        let email: String
        let password: String
        let isPersistent: Bool

        var command: Command {
            .init(email: email, password: password, isPersistent: isPersistent)
        }
    }
}
