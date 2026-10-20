import ContactAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFieldsOpenAPIRepository {
    let api: ContactAdminAPIClient

    func list() async throws -> [AdminContactFieldRow] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            switch try await client.contactFieldList() {
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
            let forms: [AdminContactFormFilterOption]
            let formFields: [String: [AdminContactFieldRow]]
            switch formsResponse {
            case .ok(let value):
                let formSchemas = try value.body.json
                forms = formSchemas.map {
                    .init(key: $0.key, name: $0.name)
                }
                formFields = Dictionary(
                    uniqueKeysWithValues: formSchemas.map { form in
                        (
                            form.key,
                            (form.items ?? []).map(Self.mapField)
                        )
                    }
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized
            case .forbidden:
                guard formKey == nil else {
                    throw OpenAPIRepositoryError.forbidden
                }
                return .init(fields: try await self.list(), forms: [])
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }

            if let formKey {
                return .init(fields: formFields[formKey] ?? [], forms: forms)
            }

            let fields = try await self.list()
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
