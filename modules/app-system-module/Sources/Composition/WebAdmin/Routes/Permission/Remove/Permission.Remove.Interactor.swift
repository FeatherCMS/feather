import FeatherWebAdmin
import SystemModule

extension Permission.Remove {
    enum Interactor {}
}

extension Permission.Remove.Interactor {
    protocol Interface: Sendable {

        func delete(ids: [String]) async throws
    }
}
