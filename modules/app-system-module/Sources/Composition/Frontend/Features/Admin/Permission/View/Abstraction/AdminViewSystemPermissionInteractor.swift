import FeatherAdmin

protocol AdminViewSystemPermissionInteractor: Sendable {

    func execute(
        entity: AdminViewSystemPermissionModel
    ) async throws -> SystemPermissionDetailsModel
}
