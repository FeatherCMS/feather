import SystemModule
import FeatherAdmin
import Hummingbird

protocol AdminListSystemPermissionInteractor: Sendable {

    func listSystemPermissions(
        page: Int,
        search: String?
    ) async throws -> AdminListSystemPermissionModel

}
