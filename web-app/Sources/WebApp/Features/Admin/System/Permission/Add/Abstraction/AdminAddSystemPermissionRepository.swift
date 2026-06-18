import Hummingbird

protocol AdminAddSystemPermissionRepository: Sendable {

    func create(
        entity: AdminAddSystemPermissionModel
    ) async throws
}
