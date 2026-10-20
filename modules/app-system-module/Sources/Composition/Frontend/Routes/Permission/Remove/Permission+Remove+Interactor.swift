import FeatherAdmin
import SystemModule

extension WebAdmin.System.Permission.Remove {
    enum Interactor {}
}

extension WebAdmin.System.Permission.Remove.Interactor {
    protocol Interface: Sendable {

        func delete(ids: [String]) async throws
    }
}
