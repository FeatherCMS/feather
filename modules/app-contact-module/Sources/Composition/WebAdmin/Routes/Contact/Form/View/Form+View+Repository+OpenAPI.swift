import ContactAdminAPI
import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension ContactModule.Form.View {
    enum Repository {}
}

extension ContactModule.Form.View.Repository {
    protocol Interface: Sendable {
        func get(key: String) async throws -> ContactModule.Form.Details.Item
    }
}

extension ContactModule.Form.View.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func get(key: String) async throws -> ContactModule.Form.Details.Item {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.contactFormGet(
                    path: .init(contactFormKey: key)
                )
                switch response {
                case .ok(let value):
                    let item = try value.body.json
                    let fieldsResponse = try await client.contactFieldList(
                        .init(query: .init(form: nil))
                    )
                    let fields: [ContactModule.FormField.Option]
                    switch fieldsResponse {
                    case .ok(let fieldsValue):
                        fields = try fieldsValue.body.json.map {
                            .init(id: $0.id, key: $0.key, label: $0.label)
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
                    return .init(
                        key: item.key,
                        name: item.name,
                        successMessage: item.successMessage,
                        failureMessage: item.failureMessage,
                        redirectUrl: item.redirectUrl,
                        selectedFieldIDs: (item.items ?? []).map(\.id),
                        availableFields: fields,
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
