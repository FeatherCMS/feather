import SystemModule
import FeatherAdmin

protocol AdminRemoveSystemPermissionInteractor: Sendable {

    func delete(ids: [String]) async throws
}
