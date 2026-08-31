protocol AdminListAuthSessionRepository: Sendable {
    func list(
        identityID: String
    ) async throws -> AdminListAuthSessionModel
}
