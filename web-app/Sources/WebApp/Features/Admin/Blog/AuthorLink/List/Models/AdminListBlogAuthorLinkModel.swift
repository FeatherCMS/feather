import AdminOpenAPI
import Foundation

struct AdminListBlogAuthorLinkModel: Sendable {
    let items: [Components.Schemas.BlogAuthorLinkListItemSchema]
    let total: Int
    let page: Int
    let pageSize: Int
}
