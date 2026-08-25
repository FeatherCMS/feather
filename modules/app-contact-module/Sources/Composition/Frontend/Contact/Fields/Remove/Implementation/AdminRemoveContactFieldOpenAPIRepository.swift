import ContactAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveContactFieldOpenAPIRepository {
    let api: ContactAdminAPIClient

    func get(id: String) async throws -> AdminContactFieldRow {
        try await AdminListContactFieldsOpenAPIRepository(api: api)
            .list().first { $0.id == id }
            ?? {
                throw OpenAPIRepositoryError.notFound(
                    message: "This contact field could not be found."
                )
            }()
    }

    func remove(id: String) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.contactFieldBulkDelete(
                body: .json(.init(ids: [id], summary: true))
            )
        }
    }
    func bulkRemove(ids: [String]) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.contactFieldBulkDelete(
                body: .json(.init(ids: ids, summary: true))
            )
        }
    }
}
