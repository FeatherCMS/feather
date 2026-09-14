import ContactAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminGetContactFormOpenAPIRepository {
    let api: ContactAdminAPIClient
    func get(id: String) async throws -> AdminContactFormDetailsItem {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormGet(
                path: .init(contactFormId: id)
            )
            switch response {
            case .ok(let value):
                let item = try value.body.json
                let fieldsResponse = try await client.contactFieldList()
                let fields: [AdminContactFormFieldOption]
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
                    id: item.id,
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
