import BlogAdminAPI
import BlogModule

extension AuthorLink.List {
    struct Model: Sendable {
        let items:
            [BlogAdminAPI.Components.Schemas.AuthorLinkQueryItemSchema]
        let total: Int
        let page: Int
        let pageSize: Int
    }
}
