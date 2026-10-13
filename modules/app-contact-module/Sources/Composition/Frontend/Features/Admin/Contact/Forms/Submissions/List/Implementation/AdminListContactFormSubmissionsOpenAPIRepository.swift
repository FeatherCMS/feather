import ContactAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFormSubmissionsOpenAPIRepository {
    let api: ContactAdminAPIClient
    func list(formId: String) async throws -> [AdminContactFormSubmissionItem] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormSubmissionList(
                path: .init(contactFormKey: formId)
            )
            switch response {
            case .ok(let value): return try value.body.json.map(map)
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
    private func map(_ item: Components.Schemas.ContactFormSubmissionSchema)
        -> AdminContactFormSubmissionItem
    {
        let values = item.values.additionalProperties
        return .init(
            id: item.id,
            formId: item.formKey,
            status: item.status,
            createdAt: DateFormatting.formatUnixTimestamp(item.createdAt),
            email: values.first { $0.key.lowercased() == "email" }?.value,
            values: values
        )
    }
}
