extension Logout {
    enum Repository {}
}

extension Logout.Repository {
    protocol Interface: Sendable {

        func logout(
            sessionToken: String
        ) async throws
    }
}
