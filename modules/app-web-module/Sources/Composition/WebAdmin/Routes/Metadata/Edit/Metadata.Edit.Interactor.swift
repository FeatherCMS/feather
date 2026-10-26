import FeatherWebAdmin
import OpenAPIRuntime
import WebModule

extension WebModule.Metadata.Edit {
    enum Interactor {}
}

extension WebModule.Metadata.Edit.Interactor {
    protocol Interface: Sendable {

        func getTemplateOptions() async throws -> [WebModule.Metadata.Edit.TemplateOption]

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
