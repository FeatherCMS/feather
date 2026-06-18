import Foundation

struct AdminListBlogPostModel: Sendable {
    let items: [AdminListBlogPostItemModel]
    let total: Int
    let page: Int
    let pageSize: Int
}
