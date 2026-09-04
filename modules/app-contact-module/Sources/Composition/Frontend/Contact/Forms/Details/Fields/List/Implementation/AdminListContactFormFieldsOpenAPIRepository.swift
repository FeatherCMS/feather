import ContactAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminListContactFormFieldsOpenAPIRepository {
    let api: ContactAdminAPIClient
    func list(formId: String) async throws -> [AdminContactFormFieldRow] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response: ContactAdminAPI.Operations.ContactFieldList.Output
            if formId.isEmpty {
                response = try await client.contactFieldList()
            }
            else {
                let formResponse = try await client.formFieldList(
                    path: .init(contactFormId: formId)
                )
                switch formResponse {
                case .ok(let value):
                    return try value.body.json.map(Self.map)
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized(
                        message: "Please sign in again to view form fields."
                    )
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden(
                        message: "Your account cannot view form fields."
                    )
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
            switch response {
            case .ok(let value):
                return try value.body.json.map(Self.map)
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view form fields."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot view form fields."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    private static func map(
        _ value: Components.Schemas.FormFieldSchema
    ) -> AdminContactFormFieldRow {
        .init(
            id: value.id,
            formId: value.formId,
            key: value.key,
            type: value._type,
            label: value.label,
            allowedValues: (value.allowedValues ?? []).joined(separator: "\n"),
            isRequired: value.isRequired,
            position: String(value.position)
        )
    }
}
