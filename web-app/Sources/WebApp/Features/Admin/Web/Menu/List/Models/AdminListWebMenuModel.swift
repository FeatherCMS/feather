import AdminOpenAPI
import Foundation

struct AdminListWebMenuModel: Sendable {
    let items: [Components.Schemas.WebMenuListItemSchema]
    let total: Int
    let page: Int
    let pageSize: Int
}
