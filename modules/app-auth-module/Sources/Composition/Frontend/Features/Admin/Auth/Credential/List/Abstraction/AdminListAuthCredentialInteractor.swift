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

protocol AdminListAuthCredentialInteractor: Sendable {
    func execute(
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
