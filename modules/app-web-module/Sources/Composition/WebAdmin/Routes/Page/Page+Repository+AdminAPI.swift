import FeatherWebAdmin
import OpenAPIRuntime
import WebDomain
import WebModule

extension Page.Repository {
    enum AdminAPI {}
}

extension Page.Repository.AdminAPI {
    protocol Interface: Sendable {
        func loadMetadata(id: String) async throws -> AdminMetadataFormValue
    }
}
