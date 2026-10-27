import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension Page.Edit.Template {
    enum Repository {}
}

extension Page.Edit.Template.Repository {
    protocol Interface: Sendable {
        func load(
            pageID: String
        ) async throws -> Content

        func save(
            metadataID: String,
            templateData: String
        ) async throws
    }
}
