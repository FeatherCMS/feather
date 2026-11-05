import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.Edit {
    enum Repository {}
}

extension WebModule.Menu.Edit.Repository {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> Menu.View.Model

        func update(
            id: String,
            input: WebModule.Menu.Form.Input
        ) async throws
    }
}
