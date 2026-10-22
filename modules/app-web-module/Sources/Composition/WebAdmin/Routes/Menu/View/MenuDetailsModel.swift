import FeatherWebAdmin
import OpenAPIRuntime
import WebAdminAPI

struct MenuDetailsModel: Sendable {
    let id: String
    let key: String
    let name: String
    let notes: String?
}
