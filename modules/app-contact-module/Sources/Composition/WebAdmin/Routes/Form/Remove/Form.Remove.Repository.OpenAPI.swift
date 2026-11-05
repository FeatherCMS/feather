import ContactAdminAPI
import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension ContactModule.Form.Remove {
    enum Repository {}
}

extension ContactModule.Form.Remove.Repository {
    protocol Interface: Sendable {
        func remove(keys: [String]) async throws
    }

    struct OpenAPI: Interface {
        let api: API.Client

        func remove(keys: [String]) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                _ = try await client.contactFormRemove(
                    body: .json(.init(ids: keys))
                )
            }
        }
    }
}
