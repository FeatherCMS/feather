import FeatherWebAdmin
import OpenAPIRuntime

struct AdminListPageModel: Sendable {
    let items: [AdminListPageItemModel]
    let total: Int
    let page: Int
    let pageSize: Int
}
