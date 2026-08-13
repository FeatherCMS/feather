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
import WebStandards

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
