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

protocol AdminAddAuthMagicLinkRepository: Sendable {

    func listEmails() async throws
        -> [AuthAdminAPI.Components.Schemas.AuthEmailDetailSchema]

    func create(
        payload: AuthMagicLinkFormPayloadModel
    ) async throws
}
