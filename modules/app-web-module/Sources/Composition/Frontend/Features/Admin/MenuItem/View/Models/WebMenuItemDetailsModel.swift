import FeatherAdmin
import Foundation
import OpenAPIRuntime

struct WebMenuItemDetailsModel: Sendable {
    let id: String
    let menuId: String
    let label: String
    let url: String
    let priority: Int
    let isBlank: Bool
    let permission: String
    let authentication: String
    let notes: String?
}
