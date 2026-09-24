import ContactAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFieldsOpenAPIRepository {
    let api: ContactAdminAPIClient

    func list() async throws -> [AdminContactFieldRow] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            switch try await client.contactFieldList() {
            case .ok(let value):
                return try value.body.json.map {
                    .init(
                        id: $0.id,
                        key: $0.key,
                        type: $0._type,
                        label: $0.label,
                        allowedValues: $0.allowedValues ?? [],
                        isRequired: $0.isRequired,
                        position: String($0.position)
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
