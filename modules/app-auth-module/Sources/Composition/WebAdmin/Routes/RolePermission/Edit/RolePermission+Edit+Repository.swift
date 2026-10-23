import AuthAdminAPI
import AuthModule
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

extension RolePermission.Edit {
    enum Repository {}
}

extension RolePermission.Edit.Repository {
    protocol Interface: Sendable {

        func fetchRoles() async throws -> [UserAdminAPI.Components.Schemas
            .UserRoleListItemSchema]

        func fetchPermissions() async throws -> [SystemAdminAPI.Components
            .Schemas
            .SystemPermissionListItemSchema]

        func fetchExistingPairs() async throws -> Set<
            RolePermission.Edit.Pair
        >

        func delete(
            pair: RolePermission.Edit.Pair
        ) async throws

        func create(
            pair: RolePermission.Edit.Pair
        ) async throws
    }
}
