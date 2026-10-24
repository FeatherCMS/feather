import FeatherWebAdmin
import SystemModule

extension Permission.Remove {
    enum Repository {}
}

extension Permission.Remove.Repository {
    protocol Interface: Sendable {

        func delete(id: String) async throws
    }
}
