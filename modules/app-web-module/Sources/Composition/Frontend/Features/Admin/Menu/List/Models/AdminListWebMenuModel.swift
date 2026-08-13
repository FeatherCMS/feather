import FeatherAdmin
import Foundation
import OpenAPIRuntime
import WebAdminAPI

struct AdminListWebMenuModel: Sendable {
    let items: [Components.Schemas.WebMenuListItemSchema]
    let total: Int
    let page: Int
    let pageSize: Int
}
