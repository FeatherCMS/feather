import AdminOpenAPI
import Foundation

struct AdminListSystemVariableModel: Sendable {
    let items: [Components.Schemas.SystemVariableListItemSchema]
    let total: Int
    let page: Int
    let pageSize: Int
}
