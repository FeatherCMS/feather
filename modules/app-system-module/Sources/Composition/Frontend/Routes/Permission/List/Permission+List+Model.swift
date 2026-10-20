import FeatherAdmin
import SystemAdminAPI
import SystemModule

extension WebAdmin.System.Permission.List {
    struct Model: Sendable {
        let items: [Components.Schemas.SystemPermissionListItemSchema]
        let total: Int
        let page: Int
        let pageSize: Int
    }
}
