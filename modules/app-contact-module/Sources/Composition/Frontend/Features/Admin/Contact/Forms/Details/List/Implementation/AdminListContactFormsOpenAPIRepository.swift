import ContactAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFormsOpenAPIRepository {
    let api: ContactAdminAPIClient
    func list() async throws -> [AdminContactFormDetailsItem] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormList()
            switch response {
            case .ok(let value):
                return try value.body.json.map {
                    .init(
                        key: $0.key,
                        name: $0.name,
                        successMessage: $0.successMessage,
                        failureMessage: $0.failureMessage,
                        redirectUrl: $0.redirectUrl,
                        selectedFieldIDs: [],
                        availableFields: [],
                        mails: []
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
}
