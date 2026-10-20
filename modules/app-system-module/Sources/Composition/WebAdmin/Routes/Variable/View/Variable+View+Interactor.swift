import FeatherAdmin
import SystemModule

extension Variable.View {
    enum Interactor {}
}

extension Variable.View.Interactor {
    protocol Interface: Sendable {

        func execute(
            entity: Variable.View.Model
        ) async throws -> SystemVariableDetailsModel
    }
}
