import Foundation

struct WebMenuItemDetailsModel: Sendable {
    let id: String
    let menuId: String
    let label: String
    let url: String
    let priority: Int
    let isBlank: Bool
    let permission: String
    let notes: String
}
