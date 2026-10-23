import ContactAdminAPI
import ContactApplication
import ContactModule
import FeatherWebShared
import OpenAPIRuntime

extension Submission.Edit.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func update(formId: String, id: String, status: String) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.contactFormSubmissionUpdate(
                    path: .init(
                        contactFormKey: formId,
                        contactFormSubmissionId: id
                    ),
                    body: .json(.init(status: status))
                )
                switch response {
                case .ok: return
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
}
