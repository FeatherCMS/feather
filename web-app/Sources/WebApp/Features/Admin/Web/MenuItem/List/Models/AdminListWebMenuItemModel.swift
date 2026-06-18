import AdminOpenAPI
import Foundation

struct AdminListWebMenuItemModel: Sendable {
    let items: [Components.Schemas.WebMenuItemListItemSchema]
    let total: Int
    let page: Int
    let pageSize: Int
}
