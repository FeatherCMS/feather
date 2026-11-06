import FeatherWebAdmin
import UserModule

extension Role.Edit {
    enum Interactor {}
}

extension Role.Edit.Interactor {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> Role.Detail.Repository.Model

        func edit(
            id: String,
            input: Role.Edit.Form.Input
        ) async throws
    }
}
