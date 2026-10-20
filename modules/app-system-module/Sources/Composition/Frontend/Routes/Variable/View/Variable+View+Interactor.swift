import FeatherAdmin
import SystemModule

extension WebAdmin.System.Variable.View {
    enum Interactor {}
}

extension WebAdmin.System.Variable.View.Interactor {
    protocol Interface: Sendable {

        func execute(
            entity: WebAdmin.System.Variable.View.Model
        ) async throws -> SystemVariableDetailsModel
    }
}
