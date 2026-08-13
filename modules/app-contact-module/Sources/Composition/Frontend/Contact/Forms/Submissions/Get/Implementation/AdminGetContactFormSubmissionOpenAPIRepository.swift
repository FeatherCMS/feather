import ContactAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminGetContactFormSubmissionOpenAPIRepository {
    let api: ContactAdminAPIClient
    func get(formId: String, id: String) async throws
        -> AdminContactFormSubmissionItem
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormSubmissionGet(
                path: .init(contactFormId: formId, contactFormSubmissionId: id)
            )
            switch response {
            case .ok(let value):
                let item = try value.body.json
                let values = item.values.additionalProperties
                return .init(
                    id: item.id,
                    formId: item.formId,
                    status: item.status,
                    createdAt: DateFormatting.formatUnixTimestamp(
                        item.createdAt
                    ),
                    email: values.first { $0.key.lowercased() == "email" }?
                        .value,
                    values: values
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This submission could not be found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view this submission."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot view this submission."
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
