import FeatherWebAdmin
import SystemModule

extension Variable.Edit {
    enum Interactor {}
}

extension Variable.Edit.Interactor {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> Variable.Edit.Model

        func edit(
            id: String,
            input: Variable.Edit.Form.Input
        ) async throws
    }
}
