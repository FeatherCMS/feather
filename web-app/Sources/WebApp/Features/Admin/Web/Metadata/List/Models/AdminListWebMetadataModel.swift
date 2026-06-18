import AdminOpenAPI
import Foundation

struct AdminListWebMetadataModel: Sendable {
    let items: [Components.Schemas.WebMetadataListItemSchema]
    let total: Int
    let page: Int
    let pageSize: Int
}
