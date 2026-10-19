import SystemModule
import FeatherAdmin

protocol AdminRemoveSystemPermissionRepository: Sendable {

    func delete(id: String) async throws
}
