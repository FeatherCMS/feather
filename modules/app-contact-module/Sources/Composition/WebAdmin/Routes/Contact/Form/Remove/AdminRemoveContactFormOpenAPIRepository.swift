import ContactAdminAPI
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactFormOpenAPIRepository {
    let api: API.Client
    func get(key: String) async throws -> AdminContactFormDetailsItem {
        try await AdminViewContactFormOpenAPIRepository(api: api).get(key: key)
    }
    func remove(keys: [String]) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.contactFormRemove(
                body: .json(.init(ids: keys))
            )
        }
    }
}
