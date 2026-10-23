import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension Page.Edit {
    enum Repository {}
}

extension Page.Edit.Repository {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> Page.Edit.Model

        func update(
            id: String,
            input: PageFormInput
        ) async throws
    }
}
