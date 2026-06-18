import Foundation

struct AdminListBlogTagModel: Sendable {
    let items: [AdminListBlogTagItemModel]
    let total: Int
    let page: Int
    let pageSize: Int
}
