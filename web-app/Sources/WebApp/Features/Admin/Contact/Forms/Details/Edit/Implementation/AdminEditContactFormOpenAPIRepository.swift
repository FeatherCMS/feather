import AdminOpenAPI

struct AdminEditContactFormOpenAPIRepository {
    let api: AdminAPI
    func get(id: String) async throws -> AdminContactFormDetailsItem {
        try await AdminGetContactFormOpenAPIRepository(api: api).get(id: id)
    }
    func update(
        id: String,
        name: String,
        successMessage: String,
        failureMessage: String,
        redirectUrl: String?,
        fieldIDs: [String],
        mails: [AdminContactFormEmail]
    ) async throws -> AdminContactFormDetailsItem {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormUpdate(
                path: .init(contactFormId: id),
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
            case .ok(let value):
                let item = try value.body.json
                return .init(
                    id: item.id,
                    name: item.name,
                    successMessage: item.successMessage,
                    failureMessage: item.failureMessage,
                    redirectUrl: item.redirectUrl,
                    selectedFieldIDs: (item.items ?? []).map(\.id),
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
                    message: "Please sign in again to edit contact forms."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit contact forms."
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This contact form could not be found."
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
