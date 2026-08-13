import FeatherAdmin

struct AdminAddUserIdentityDefaultInteractor: AdminAddUserIdentityInteractor {
    let repository: any AdminAddUserIdentityRepository

    func execute(
        entity: AdminAddUserIdentityModel
    ) async throws {
        try await repository.create(payload: entity.payload)
    }
}
