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

protocol AdminListAuthEmailRepository: Sendable {

    func list(
        page: Int,
        size: Int,
        search: String?,
        userID: String?
    ) async throws -> (
        items: [AuthAdminAPI.Components.Schemas.AuthEmailDetailSchema],
        identityNames: [String: String],
        total: Int,
        page: Int,
        size: Int
    )

}
