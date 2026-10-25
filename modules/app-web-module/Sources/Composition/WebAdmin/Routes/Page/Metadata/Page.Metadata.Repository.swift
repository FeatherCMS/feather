import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Page.Metadata {
    enum Repository {}
}

extension WebModule.Page.Metadata.Repository {
    protocol Interface: Sendable {
        func load(id: String) async throws -> AdminMetadataFormValue
    }
}
