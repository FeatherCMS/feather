import ContactAdminAPI
import ContactModule
import ContactWebShared
import FeatherWebShared
import OpenAPIRuntime

extension Form.Add.Repository {
    struct OpenAPI: Interface {
        let api: ContactAdminAPIClient

        func availableFields() async throws -> [AdminContactFormFieldOption] {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.contactFieldList(
                    .init(query: .init(form: nil))
                )
                switch response {
                case .ok(let value):
                    return try value.body.json.map {
                        AdminContactFormFieldOption(
                            id: $0.id,
                            key: $0.key,
                            label: $0.label
                        )
                    }
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

        func create(entity: Form.Add.Model) async throws
            -> AdminContactFormDetailsItem
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.contactFormCreate(
                    body: .json(
                        .init(
                            key: entity.key,
                            name: entity.name,
                            successMessage: entity.successMessage,
                            failureMessage: entity.failureMessage,
                            redirectUrl: entity.redirectUrl,
                            fieldIds: entity.fieldIDs,
                            mails: entity.mails.map {
                                (mail: AdminContactFormEmail)
                                    -> Components.Schemas
                                    .SubmissionMailInputSchema in
                                .init(
                                    mailFrom: mail.mailFrom,
                                    mailTo: mail.mailTo,
                                    subject: mail.subject,
                                    additionalHeaders: mail.additionalHeaders,
                                    messageBody: mail.messageBody
                                )
                            }
                        )
                    )
                )
                switch response {
                case .created(let value):
                    let item = try value.body.json
                    return .init(
                        key: item.key,
                        name: item.name,
                        successMessage: item.successMessage,
                        failureMessage: item.failureMessage,
                        redirectUrl: item.redirectUrl,
                        selectedFieldIDs: [],
                        availableFields: [],
                        mails: (item.mails ?? [])
                            .map {
                                .init(
                                    id: $0.id,
                                    mailFrom: $0.mailFrom,
                                    mailTo: $0.mailTo,
                                    subject: $0.subject,
                                    additionalHeaders: $0.additionalHeaders,
                                    messageBody: $0.messageBody
                                )
                            }
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
    }
}
