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

protocol AdminAddAuthCredentialInteractor: Sendable {
    func listIdentities() async throws -> [AuthCredentialIdentityOption]
    func execute(payload: AuthCredentialFormPayloadModel) async throws
}
