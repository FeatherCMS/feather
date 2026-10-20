import FeatherAdmin
import SystemModule

extension WebAdmin.System.Permission.Remove {
    enum Repository {}
}

extension WebAdmin.System.Permission.Remove.Repository {
    protocol Interface: Sendable {

        func delete(id: String) async throws
    }
}
