import FeatherAdmin
import Foundation
import OpenAPIRuntime

struct AdminListWebPageModel: Sendable {
    let items: [AdminListWebPageItemModel]
    let total: Int
    let page: Int
    let pageSize: Int
}
