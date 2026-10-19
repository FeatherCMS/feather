import SystemModule
import FeatherAdmin

protocol AdminRemoveSystemVariableInteractor: Sendable {

    func delete(
        ids: [String]
    ) async throws
}
