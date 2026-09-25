import ContactAdminAPI
import FeatherAdmin
import OpenAPIRuntime

struct AdminViewContactFormSubmissionOpenAPIRepository {
    let api: ContactAdminAPIClient
    func get(formId: String, id: String) async throws
        -> AdminContactFormSubmissionItem
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormSubmissionGet(
                path: .init(
                    contactFormKey: formId,
                    contactFormSubmissionId: id
                )
            )
            switch response {
            case .ok(let value):
                let item = try value.body.json
                let values = item.values.additionalProperties
                return .init(
                    id: item.id,
                    formId: item.formKey,
                    status: item.status,
                    createdAt: DateFormatting.formatUnixTimestamp(
                        item.createdAt
                    ),
                    email: values.first { $0.key.lowercased() == "email" }?
                        .value,
                    values: values
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound
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
