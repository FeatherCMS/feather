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

protocol AdminListAuthMagicLinkRepository: Sendable {

    func list(
        page: Int,
        size: Int,
        search: String?,
        userID: String?
    ) async throws -> (
        items: [AuthAdminAPI.Components.Schemas.AuthMagicLinkListItemSchema],
        emailByAuthEmailId: [String: String],
        total: Int,
        page: Int,
        size: Int
    )

}
