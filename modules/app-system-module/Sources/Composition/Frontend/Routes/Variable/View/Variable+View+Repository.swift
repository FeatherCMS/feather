import FeatherAdmin
import SystemModule

extension WebAdmin.System.Variable.View {
    enum Repository {}
}

extension WebAdmin.System.Variable.View.Repository {
    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> SystemVariableDetailsModel
    }
}
