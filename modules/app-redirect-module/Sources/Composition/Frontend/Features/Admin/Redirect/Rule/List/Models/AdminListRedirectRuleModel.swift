import FeatherAdmin
import Foundation
import RedirectAdminAPI

struct AdminListRedirectRuleModel: Sendable {
    let items: [RedirectAdminAPI.Components.Schemas.RedirectRuleListItemSchema]
    let total: Int
    let page: Int
    let pageSize: Int
    let statusCode: String
}
