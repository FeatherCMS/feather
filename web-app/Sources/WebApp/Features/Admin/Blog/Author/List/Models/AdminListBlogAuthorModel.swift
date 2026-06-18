import Foundation

struct AdminListBlogAuthorModel: Sendable {
    let items: [AdminListBlogAuthorItemModel]
    let total: Int
    let page: Int
    let pageSize: Int
}
