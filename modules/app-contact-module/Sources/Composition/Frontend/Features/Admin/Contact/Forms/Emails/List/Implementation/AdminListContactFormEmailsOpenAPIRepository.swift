import ContactAdminAPI
import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFormEmailsOpenAPIRepository {
    let api: ContactAdminAPIClient
    func get(id: String) async throws -> AdminContactFormDetailsItem {
        try await AdminViewContactFormOpenAPIRepository(api: api).get(key: id)
    }
}
