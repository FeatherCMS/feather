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

protocol AdminAddAuthCredentialInteractor: Sendable {
    func listEmails() async throws -> [AuthCredentialIdentityOption]
    func execute(payload: AuthCredentialFormPayloadModel) async throws
}
