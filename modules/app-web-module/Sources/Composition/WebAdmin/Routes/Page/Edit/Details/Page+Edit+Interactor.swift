import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension Page.Edit {
    enum Interactor {}
}

extension Page.Edit.Interactor {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> Page.Edit.Model

        func update(
            id: String,
            input: Page.Form.Input
        ) async throws
    }
}
