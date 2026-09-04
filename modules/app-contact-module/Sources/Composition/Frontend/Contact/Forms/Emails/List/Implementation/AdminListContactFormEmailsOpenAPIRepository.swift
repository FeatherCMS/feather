import ContactAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminListContactFormEmailsOpenAPIRepository {
    let api: ContactAdminAPIClient
    func get(id: String) async throws -> AdminContactFormDetailsItem {
        try await AdminGetContactFormOpenAPIRepository(api: api).get(id: id)
    }
}
