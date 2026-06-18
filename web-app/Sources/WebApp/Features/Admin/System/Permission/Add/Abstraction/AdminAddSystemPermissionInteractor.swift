import Hummingbird

protocol AdminAddSystemPermissionInteractor: Sendable {

    func execute(
        entity: AdminAddSystemPermissionModel
    ) async throws
}
