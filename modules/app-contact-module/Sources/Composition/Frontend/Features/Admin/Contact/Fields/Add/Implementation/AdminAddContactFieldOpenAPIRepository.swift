import ContactAdminAPI
import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddContactFieldOpenAPIRepository {
    let api: ContactAdminAPIClient
    func createField(
        form: ContactFieldFormInput,
        assignToFormKey formKey: String?
    ) async throws {
        let assignmentSucceeded =
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
                let response = try await client.contactFieldCreate(body: body)
                let fieldID: String
                switch response {
                case .created(let value):
                    fieldID = try value.body.json.id
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

                guard let formKey else { return true }
                do {
                    let formResponse = try await client.contactFormGet(
                        path: .init(contactFormKey: formKey)
                    )
                    let form:
                        ContactAdminAPI.Components.Schemas.ContactFormSchema
                    switch formResponse {
                    case .ok(let value):
                        form = try value.body.json
                    default:
                        return false
                    }

                    var fieldIDs = (form.items ?? []).map(\.id)
                    guard !fieldIDs.contains(fieldID) else { return true }
                    fieldIDs.append(fieldID)
                    let updateResponse = try await client.contactFormUpdate(
                        path: .init(contactFormKey: formKey),
                        body: .json(
                            .init(
                                key: form.key,
                                name: form.name,
                                successMessage: form.successMessage,
                                failureMessage: form.failureMessage,
                                redirectUrl: form.redirectUrl,
                                fieldIds: fieldIDs,
                                mails: (form.mails ?? [])
                                    .map {
                                        .init(
                                            mailFrom: $0.mailFrom,
                                            mailTo: $0.mailTo,
                                            subject: $0.subject,
                                            additionalHeaders: $0
                                                .additionalHeaders,
                                            messageBody: $0.messageBody
                                        )
                                    }
                            )
                        )
                    )
                    guard case .ok = updateResponse else { return false }
                    return true
                }
                catch {
                    return false
                }
            }
        guard assignmentSucceeded else {
            throw AdminAddContactFieldError.createdButNotAssigned
        }
    }
}
