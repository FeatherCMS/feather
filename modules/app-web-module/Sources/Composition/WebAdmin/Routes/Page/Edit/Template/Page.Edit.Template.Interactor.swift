import OpenAPIRuntime
import WebModule

extension Page.Edit.Template {
    enum Interactor {}
}

extension Page.Edit.Template.Interactor {
    protocol Interface: Sendable {
        func load(
            pageID: String,
            metadataID: String
        ) async throws -> Page.Edit.Template.Model

        func save(
            pageID: String,
            metadataID: String,
            input: Page.Edit.Template.Input
        ) async throws -> Page.Edit.Template.Model
    }
}
