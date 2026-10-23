import ContactAdminAPI
import ContactApplication
import ContactModule
import FeatherWebShared
import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFieldsOpenAPIRepository {
    let api: ContactAdminAPIClient

    func list(formKey: String? = nil) async throws -> [AdminContactFieldRow] {
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

    func listWithForms(formKey: String?) async throws -> AdminContactFieldsList
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let formsResponse = try await client.contactFormList()
            let forms: [FormField.List.FormOption]
            switch formsResponse {
            case .ok(let value):
                let formSchemas = try value.body.json
                forms = formSchemas.map {
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

            let fields = try await self.list(formKey: formKey)
            return .init(fields: fields, forms: forms)
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
