protocol AdminListAuthSessionInteractor: Sendable {
    func list(
        identityID: String
    ) async throws -> AdminListAuthSessionModel
}
