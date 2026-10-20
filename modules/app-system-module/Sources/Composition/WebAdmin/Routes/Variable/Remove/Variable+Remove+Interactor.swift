import FeatherAdmin
import SystemModule

extension Variable.Remove {
    enum Interactor {}
}

extension Variable.Remove.Interactor {
    protocol Interface: Sendable {

        func delete(
            ids: [String]
        ) async throws
    }
}
