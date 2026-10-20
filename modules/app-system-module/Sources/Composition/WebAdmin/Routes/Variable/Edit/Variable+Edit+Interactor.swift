import FeatherWebAdmin
import SystemModule

extension Variable.Edit {
    enum Interactor {}
}

extension Variable.Edit.Interactor {
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
