import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
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

protocol AdminListAuthCredentialIdentityRepository: Sendable {
    func list(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [UserAdminAPI.Components.Schemas.UserIdentityListItemSchema],
        total: Int,
        page: Int,
        size: Int
    )
}
