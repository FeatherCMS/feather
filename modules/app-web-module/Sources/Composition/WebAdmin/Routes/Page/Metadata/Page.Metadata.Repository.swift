import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
import WebModule

extension Page.Metadata {
    enum Repository {}
}

extension Page.Metadata.Repository {
    protocol Interface: Sendable {
        func load(id: String) async throws -> AdminMetadataFormValue
    }
}
