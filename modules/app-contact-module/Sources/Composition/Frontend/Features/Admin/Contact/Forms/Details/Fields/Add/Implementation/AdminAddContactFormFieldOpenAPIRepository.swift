import ContactAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddContactFormFieldOpenAPIRepository {
    let api: ContactAdminAPIClient
    func createField(formId: String, form: ContactFormFieldAddForm) async throws
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let body: Components.RequestBodies.FormFieldCreateRequestBody =
                .json(
                    .init(
                        key: form.key,
                        _type: form.type,
                        label: form.label,
                        allowedValues: form.normalizedAllowedValues,
                        isRequired: form.isRequiredValue
                    )
                )
            if formId.isEmpty {
                switch try await client.contactFieldCreate(body: body) {
                case .created: return
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
            let response = try await client.formFieldCreate(
                path: .init(contactFormId: formId),
                body: body
            )
            switch response {
            case .created: return
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
