import FeatherAdmin
import Foundation
import OpenAPIRuntime

struct AdminGetWebMenuModel: Sendable {
    let id: String
    let isAdded: Bool
    let isRemoved: Bool
}
