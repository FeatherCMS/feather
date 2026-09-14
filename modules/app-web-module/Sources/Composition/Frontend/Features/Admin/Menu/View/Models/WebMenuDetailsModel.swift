import FeatherAdmin
import Foundation
import OpenAPIRuntime
import WebAdminAPI

struct WebMenuDetailsModel: Sendable {
    let id: String
    let key: String
    let name: String
    let notes: String?
}
