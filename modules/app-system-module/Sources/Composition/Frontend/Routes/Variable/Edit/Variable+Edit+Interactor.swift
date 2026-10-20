import FeatherAdmin
import SystemModule

extension WebAdmin.System.Variable.Edit {
    enum Interactor {}
}

extension WebAdmin.System.Variable.Edit.Interactor {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> SystemVariableEditModel

        func edit(
            id: String,
            input: SystemVariableEditFormInput
        ) async throws
    }
}
