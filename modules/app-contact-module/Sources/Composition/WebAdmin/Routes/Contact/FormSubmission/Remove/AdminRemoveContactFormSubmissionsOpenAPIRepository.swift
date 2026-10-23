import ContactAdminAPI
import ContactApplication
import ContactModule

struct AdminRemoveContactFormSubmissionsOpenAPIRepository {
    let api: API.Client
    func get(formId: String, id: String) async throws
        -> Submission.Item
    {
        try await Submission.Detail.Repository.OpenAPI(api: api)
            .get(formId: formId, id: id)
    }
    func remove(formId: String, id: String) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.contactFormSubmissionRemove(
                path: .init(contactFormKey: formId),
                body: .json(.init(ids: [id]))
            )
        }
    }
    func remove(formId: String, ids: [String]) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.contactFormSubmissionRemove(
                path: .init(contactFormKey: formId),
                body: .json(.init(ids: ids))
            )
        }
    }
}
