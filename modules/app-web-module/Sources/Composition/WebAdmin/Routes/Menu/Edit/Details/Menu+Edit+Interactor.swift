import FeatherWebAdmin
import WebDomain
import OpenAPIRuntime

extension WebDomain.Menu.Edit {
    enum Interactor {}
}

extension WebDomain.Menu.Edit.Interactor {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> MenuDetailsModel

        func update(
            id: String,
            input: MenuFormInput
        ) async throws
    }
}
