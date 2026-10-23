extension Login {
    enum Repository {}
}

extension Login.Repository {
    protocol Interface: Sendable {

        func login(
            _ command: Login.Command
        ) async throws -> Login.Result
    }
}
