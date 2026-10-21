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

protocol AdminListAuthCredentialRepository: Sendable {
    func list(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [AuthAdminAPI.Components.Schemas.AuthCredentialListItemSchema],
        total: Int,
        page: Int,
        size: Int
    )
}
