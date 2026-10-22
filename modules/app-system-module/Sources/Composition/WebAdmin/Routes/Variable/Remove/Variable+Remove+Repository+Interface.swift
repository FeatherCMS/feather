import FeatherWebAdmin
import SystemModule

extension Variable.Remove.Repository {
    protocol Interface: Sendable {

        func delete(
            ids: [String]
        ) async throws
    }
}
