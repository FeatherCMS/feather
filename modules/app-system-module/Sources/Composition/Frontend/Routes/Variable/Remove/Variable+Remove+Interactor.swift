import FeatherAdmin
import SystemModule

extension WebAdmin.System.Variable.Remove {
    enum Interactor {}
}

extension WebAdmin.System.Variable.Remove.Interactor {
    protocol Interface: Sendable {

        func delete(
            ids: [String]
        ) async throws
    }
}
