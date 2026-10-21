import AuthAdminAPI
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

struct AdminEditAuthAccessControlState: Sendable {
    let isEdited: Bool
    let error: String?
    let canEdit: Bool
    let roles: [UserAdminAPI.Components.Schemas.UserRoleListItemSchema]
    let permissions:
        [SystemAdminAPI.Components.Schemas.SystemPermissionListItemSchema]
    let selectedPairs: Set<String>
}
