import FeatherWebAdmin
import SystemModule

extension Variable.View.Interactor {
    protocol Interface: Sendable {

        func execute(
            entity: Variable.View.Model
        ) async throws -> SystemVariableDetailsModel
    }
}
