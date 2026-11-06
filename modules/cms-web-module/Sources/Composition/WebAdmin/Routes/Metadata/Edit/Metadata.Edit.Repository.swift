import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension WebModule.Metadata.Edit {
    enum Repository {}
}

extension WebModule.Metadata.Edit.Repository {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> WebModule.Metadata.Edit.Model

        func load(
            referenceType: String,
            referenceID: String
        ) async throws -> WebModule.Metadata.Edit.Model

        func update(
            id: String,
            input: WebModule.Metadata.Edit.Input
        ) async throws
    }
}
