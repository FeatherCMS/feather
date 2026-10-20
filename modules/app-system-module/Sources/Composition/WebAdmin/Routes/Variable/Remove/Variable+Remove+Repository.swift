import FeatherAdmin
import SystemModule

extension Variable.Remove {
    enum Repository {}
}

extension Variable.Remove.Repository {
    protocol Interface: Sendable {

        func delete(
            ids: [String]
        ) async throws
    }
}
