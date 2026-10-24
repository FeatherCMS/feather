import ContactAdminAPI
import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension ContactModule.Form.Edit {
    enum Repository {}
}

extension ContactModule.Form.Edit.Repository {
    protocol Interface: Sendable {
        func get(key: String) async throws -> ContactModule.Form.Details.Item
        func update(
            key: String,
            newKey: String,
            name: String,
            successMessage: String,
            failureMessage: String,
            redirectUrl: String?,
            fieldIDs: [String],
            mails: [ContactModule.Form.Email]
        ) async throws -> ContactModule.Form.Details.Item
    }
}

extension ContactModule.Form.Edit.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func get(key: String) async throws -> ContactModule.Form.Details.Item {
            try await ContactModule.Form.View.Repository.OpenAPI(api: api)
                .get(key: key)
        }

        func update(
            key: String,
            newKey: String,
            name: String,
            successMessage: String,
            failureMessage: String,
            redirectUrl: String?,
            fieldIDs: [String],
            mails: [ContactModule.Form.Email]
        ) async throws -> ContactModule.Form.Details.Item {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.contactFormUpdate(
                    path: .init(contactFormKey: key),
                    body: .json(
                        .init(
                            key: newKey,
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
                        key: item.key,
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
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .notFound:
                    throw OpenAPIRepositoryError.notFound
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
