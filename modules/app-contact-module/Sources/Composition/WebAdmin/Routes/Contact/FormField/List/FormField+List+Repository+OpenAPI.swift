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

extension FormField.List {
    enum Repository {}
}

extension FormField.List.Repository {
    protocol Interface: Sendable {
        func search(
            page: Int,
            search: String?,
            formKey: String?
        ) async throws -> FormField.List.Model
    }
}

extension FormField.List.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func search(
            page: Int,
            search: String?,
            formKey: String?
        ) async throws -> FormField.List.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let formsResponse = try await client.contactFormList()
                let forms: [FormField.List.FormOption]
                switch formsResponse {
                case .ok(let value):
                    forms = try value.body.json.map {
                        .init(key: $0.key, name: $0.name)
                    }
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    forms = []
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }

                let query = Components.Schemas
                    .ContactFieldQueryItemSearchRequestQuerySchema(
                        page: .init(
                            size: FormField.List.Router.pageSize,
                            number: page
                        ),
                        filters: .init(
                            search: search?.isEmpty == false ? search : nil,
                            form: formKey
                        )
                    )
                let response = try await client.contactFieldQuery(
                    .init(body: .json(query))
                )
                switch response {
                case .ok(let value):
                    let result = try value.body.json
                    let fields = result.data.items.map {
                        AdminContactFieldRow(
                            id: $0.id,
                            key: $0.key,
                            type: $0._type,
                            label: $0.label,
                            allowedValues: [],
                            isRequired: $0.isRequired,
                            position: "0"
                        )
                    }
                    return .init(
                        fields: fields,
                        forms: forms,
                        total: result.data.total
                    )
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

        func list(formKey: String? = nil) async throws -> [AdminContactFieldRow]
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                switch try await client.contactFieldList(
                    .init(query: .init(form: formKey))
                ) {
                case .ok(let value):
                    return try value.body.json.map(Self.mapField)
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

        private static func mapField(
            _ field: ContactAdminAPI.Components.Schemas.FormFieldSchema
        ) -> AdminContactFieldRow {
            .init(
                id: field.id,
                key: field.key,
                type: field._type,
                label: field.label,
                allowedValues: field.allowedValues ?? [],
                isRequired: field.isRequired,
                position: String(field.position)
            )
        }
    }
}
