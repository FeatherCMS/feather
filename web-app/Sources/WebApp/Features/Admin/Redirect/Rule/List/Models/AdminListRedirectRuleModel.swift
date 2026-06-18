import AdminOpenAPI
import Foundation

struct AdminListRedirectRuleModel: Sendable {
    let items: [Components.Schemas.RedirectRuleListItemSchema]
    let total: Int
    let page: Int
    let pageSize: Int
    let statusCode: String
}
