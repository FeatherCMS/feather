import AdminOpenAPI
import Foundation

struct AdminEditAuthAccessControlState: Sendable {
    let isEdited: Bool
    let error: String?
    let canEdit: Bool
    let roles: [Components.Schemas.UserRoleListItemSchema]
    let permissions: [Components.Schemas.SystemPermissionListItemSchema]
    let selectedPairs: Set<String>
}
