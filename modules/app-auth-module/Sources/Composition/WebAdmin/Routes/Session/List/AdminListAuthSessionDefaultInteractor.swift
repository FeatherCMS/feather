struct AdminListAuthSessionDefaultInteractor:
    AdminListAuthSessionInteractor
{
    let repository: any AdminListAuthSessionRepository

    func list(
        identityID: String
    ) async throws -> AdminListAuthSessionModel {
        try await repository.list(identityID: identityID)
    }
}
