import ContactAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveContactFormSubmissionsOpenAPIRepository {
    let api: ContactAdminAPIClient
    func get(formId: String, id: String) async throws
        -> AdminContactFormSubmissionItem
    {
        try await AdminGetContactFormSubmissionOpenAPIRepository(api: api)
            .get(formId: formId, id: id)
    }
    func remove(formId: String, id: String) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormSubmissionDelete(
                path: .init(contactFormId: formId, contactFormSubmissionId: id)
            )
            switch response {
            case .noContent: return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This submission could not be found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to delete submissions."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot delete submissions."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
    func bulkRemove(formId: String, ids: [String]) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.contactFormSubmissionBulkDelete(
                path: .init(contactFormId: formId),
                body: .json(.init(ids: ids, summary: true))
            )
        }
    }
}
