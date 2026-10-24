import ContactAdminAPI
import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension FormField.Remove {
    enum Repository {}
}

extension FormField.Remove.Repository {
    protocol Interface: Sendable {
        func get(id: String) async throws -> FormField.Model
        func remove(id: String) async throws
        func remove(ids: [String]) async throws
    }

    struct OpenAPI: Interface {
        let api: API.Client

        func get(id: String) async throws -> FormField.Model {
            try await FormField.List.Repository.OpenAPI(api: api)
                .list().first { $0.id == id }
                ?? {
                    throw OpenAPIRepositoryError.notFound
                }()
        }

        func remove(id: String) async throws {
            try await remove(ids: [id])
        }

        func remove(ids: [String]) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                _ = try await client.contactFieldRemove(
                    body: .json(.init(ids: ids))
                )
            }
        }
    }
}
