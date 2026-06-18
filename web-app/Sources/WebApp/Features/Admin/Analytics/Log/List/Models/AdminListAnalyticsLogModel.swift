import AdminOpenAPI
import Foundation

struct AdminListAnalyticsLogModel: Sendable {
    let items: [Components.Schemas.AnalyticsLogListItemSchema]
    let total: Int
    let page: Int
    let pageSize: Int
    let source: String
    let method: String
    let responseCode: String
}
