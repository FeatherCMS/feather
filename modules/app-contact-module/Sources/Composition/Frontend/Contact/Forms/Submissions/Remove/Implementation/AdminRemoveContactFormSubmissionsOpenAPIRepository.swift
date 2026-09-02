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
            _ = try await client.contactFormSubmissionDelete(
                path: .init(contactFormId: formId),
                body: .json(.init(ids: [id], results: false, summary: true))
            )
        }
    }
    func remove(formId: String, ids: [String]) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.contactFormSubmissionDelete(
                path: .init(contactFormId: formId),
                body: .json(.init(ids: ids, results: false, summary: true))
            )
        }
    }
}
