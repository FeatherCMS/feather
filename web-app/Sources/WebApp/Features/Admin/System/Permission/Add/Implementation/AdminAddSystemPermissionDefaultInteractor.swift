import Hummingbird

struct AdminAddSystemPermissionDefaultInteractor:
    AdminAddSystemPermissionInteractor
{
    let repository: any AdminAddSystemPermissionRepository

    func execute(
        entity: AdminAddSystemPermissionModel
    ) async throws {
        try await repository.create(entity: entity)
    }
}
