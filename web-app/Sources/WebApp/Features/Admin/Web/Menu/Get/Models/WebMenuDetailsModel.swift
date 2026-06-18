import AdminOpenAPI
import Foundation

struct WebMenuDetailsModel: Sendable {
    let id: String
    let key: String
    let name: String
    let notes: String
    let items: [Components.Schemas.WebMenuItemListItemSchema]
}
