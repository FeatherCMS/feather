import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherWebAdmin
import FeatherValidation
import FeatherValidationFoundation
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

protocol AdminEditAuthAccessControlRepository: Sendable {

    func fetchRoles() async throws -> [UserAdminAPI.Components.Schemas
        .UserRoleListItemSchema]

    func fetchPermissions() async throws -> [SystemAdminAPI.Components.Schemas
        .SystemPermissionListItemSchema]

    func fetchExistingPairs() async throws -> Set<
        AdminEditAuthAccessControlPair
    >

    func delete(
        pair: AdminEditAuthAccessControlPair
    ) async throws

    func create(
        pair: AdminEditAuthAccessControlPair
    ) async throws
}
