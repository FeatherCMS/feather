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
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.contactFieldGet(
                    path: .init(formFieldId: id)
                )

                switch response {
                case .ok(let value):
                    let field = try value.body.json
                    return FormField.Model(
                        id: field.id,
                        key: field.key,
                        type: field._type,
                        label: field.label,
                        allowedValues: field.allowedValues ?? [],
                        isRequired: field.isRequired,
                        position: String(field.position)
                    )
                case .notFound:
                    throw OpenAPIRepositoryError.notFound
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
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
