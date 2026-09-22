
protocol AppLogoutAuthRepository: Sendable {

    func logout(
        sessionToken: String
    ) async throws
}
