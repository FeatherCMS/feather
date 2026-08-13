import FeatherAdmin
import Foundation
import OpenAPIRuntime
import WebAdminAPI

struct AdminListWebMetadataModel: Sendable {
    let items: [Components.Schemas.WebMetadataListItemSchema]
    let total: Int
    let page: Int
    let pageSize: Int
}
