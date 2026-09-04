import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebComponents
import WebBuilders

struct AdminEditAuthAccessControlState: Sendable {
    let isEdited: Bool
    let error: String?
    let canEdit: Bool
    let roles: [UserAdminAPI.Components.Schemas.UserRoleListItemSchema]
    let permissions:
        [SystemAdminAPI.Components.Schemas.SystemPermissionListItemSchema]
    let selectedPairs: Set<String>
}
