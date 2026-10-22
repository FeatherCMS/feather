import FeatherWebAdmin
import SystemModule

extension Permission.Remove.Interactor {
    protocol Interface: Sendable {

        func delete(ids: [String]) async throws
    }
}
