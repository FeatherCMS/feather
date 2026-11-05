import ContactAdminAPI
import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension FormField.Edit {
    enum Repository {}
}

extension FormField.Edit.Repository {
    protocol Interface: Sendable {
        func get(id: String) async throws -> FormField.Model
        func update(id: String, form: FormField.Add.Form.Input) async throws
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

        func update(id: String, form: FormField.Add.Form.Input) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let body: Components.RequestBodies.FormFieldPatchRequestBody =
                    .json(
                        .init(
                            key: form.key,
                            _type: form.type,
                            label: form.label,
                            allowedValues: form.normalizedAllowedValues,
                            isRequired: form.isRequiredValue
                        )
                    )
                let response = try await client.contactFieldPatch(
                    path: .init(formFieldId: id),
                    query: .init(
                        updateMask: "key,type,label,allowedValues,isRequired"
                    ),
                    body: body
                )
                switch response {
                case .ok: return
                case .badRequest(let response):
                    let data = try JSONEncoder()
                        .encode(try response.body.json)
                    throw OpenAPIRepositoryError.parsedFailure(
                        statusCode: 400,
                        responseBody: String(data: data, encoding: .utf8)
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
    }
}
