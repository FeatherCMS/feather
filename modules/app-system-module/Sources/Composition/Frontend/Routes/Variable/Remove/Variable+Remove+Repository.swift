import FeatherAdmin
import SystemModule

extension WebAdmin.System.Variable.Remove {
    enum Repository {}
}

extension WebAdmin.System.Variable.Remove.Repository {
    protocol Interface: Sendable {

        func delete(
            ids: [String]
        ) async throws
    }
}
