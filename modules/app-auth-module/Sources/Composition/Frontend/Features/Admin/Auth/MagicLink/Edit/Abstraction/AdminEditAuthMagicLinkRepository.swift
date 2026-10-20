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

protocol AdminEditAuthMagicLinkRepository: Sendable {

    func listEmails() async throws -> [AuthAdminAPI.Components.Schemas
        .AuthEmailDetailSchema]

    func get(
        id: String
    ) async throws -> AuthMagicLinkDetailsModel

    func update(
        id: String,
        payload: AuthMagicLinkFormPayloadModel
    ) async throws
}
