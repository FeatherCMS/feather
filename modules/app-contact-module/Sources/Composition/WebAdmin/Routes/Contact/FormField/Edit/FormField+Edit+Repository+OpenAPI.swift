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
            try await FormField.List.Repository.OpenAPI(api: api)
                .list().first { $0.id == id }
                ?? {
                    throw OpenAPIRepositoryError.notFound
                }()
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
                let response = try await client.contactFieldUpdate(
                    path: .init(formFieldId: id),
                    body: body
                )
                switch response {
                case .ok: return
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
