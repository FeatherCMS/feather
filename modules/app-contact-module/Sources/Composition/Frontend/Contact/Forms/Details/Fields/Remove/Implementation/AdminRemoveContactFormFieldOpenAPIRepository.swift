import ContactAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveContactFormFieldOpenAPIRepository {
    let api: ContactAdminAPIClient
    func get(formId: String, id: String) async throws
        -> AdminContactFormFieldRow
    {
        try await AdminListContactFormFieldsOpenAPIRepository(api: api)
            .list(formId: formId).first { $0.id == id }
            ?? {
                throw OpenAPIRepositoryError.notFound(
                    message: "This form field could not be found."
                )
            }()
    }
    func remove(formId: String, id: String) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.contactFieldBulkDelete(body: .json(.init(ids: [id], summary: true)))
        }
    }
    func bulkRemove(formId: String, ids: [String]) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            if formId.isEmpty {
                _ = try await client.contactFieldBulkDelete(
                    body: .json(.init(ids: ids, summary: true))
                )
            }
            else {
                _ = try await client.formFieldBulkDelete(
                    path: .init(contactFormId: formId),
                    body: .json(.init(ids: ids, summary: true))
                )
            }
        }
    }
}
