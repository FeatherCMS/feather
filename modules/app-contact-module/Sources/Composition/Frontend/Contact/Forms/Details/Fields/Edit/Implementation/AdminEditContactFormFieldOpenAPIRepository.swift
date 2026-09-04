import ContactAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminEditContactFormFieldOpenAPIRepository {
    let api: ContactAdminAPIClient
    func get(formId: String, id: String) async throws
        -> AdminContactFormFieldRow
    {
        try await AdminListContactFormFieldsOpenAPIRepository(api: api)
            .list(formId: formId).first { $0.id == id }
            ?? {
                throw OpenAPIRepositoryError.notFound(
                    message: "This form field could not be found."
                )
            }()
    }
    func update(formId: String, id: String, form: ContactFormFieldAddForm)
        async throws
    {
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
            if formId.isEmpty {
                switch try await client.contactFieldUpdate(
                    path: .init(formFieldId: id),
                    body: body
                ) {
                case .ok: return
                case .notFound:
                    throw OpenAPIRepositoryError.notFound(
                        message: "This form field could not be found."
                    )
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized(
                        message: "Please sign in again to edit form fields."
                    )
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden(
                        message: "Your account cannot edit form fields."
                    )
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
            let response = try await client.formFieldUpdate(
                path: .init(contactFormId: formId, formFieldId: id),
                body: body
            )
            switch response {
            case .ok: return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This form field could not be found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to edit form fields."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit form fields."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
