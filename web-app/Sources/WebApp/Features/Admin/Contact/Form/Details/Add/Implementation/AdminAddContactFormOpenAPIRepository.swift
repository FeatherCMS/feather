import AdminOpenAPI

struct AdminAddContactFormOpenAPIRepository {
    let api: AdminAPI

    func availableFields() async throws -> [AdminContactFormFieldOption] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFieldList()
            switch response {
            case .ok(let value):
                return try value.body.json.map {
                    .init(id: $0.id, key: $0.key, label: $0.label)
                }
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view contact fields."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot view contact fields."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func create(
        name: String,
        successMessage: String,
        failureMessage: String,
        redirectUrl: String?,
        fieldIDs: [String],
        mails: [AdminContactFormEmail]
    ) async throws -> AdminContactFormDetailsItem {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormCreate(
                body: .json(
                    .init(
                        name: name,
                        successMessage: successMessage,
                        failureMessage: failureMessage,
                        redirectUrl: redirectUrl,
                        fieldIds: fieldIDs,
                        mails: mails.map {
                            .init(
                                mailFrom: $0.mailFrom,
                                mailTo: $0.mailTo,
                                subject: $0.subject,
                                additionalHeaders: $0.additionalHeaders,
                                messageBody: $0.messageBody
                            )
                        }
                    )
                )
            )
            switch response {
            case .created(let value):
                let item = try value.body.json
                return .init(
                    id: item.id,
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
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to create contact forms."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot create contact forms."
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
