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

protocol AdminAddAuthCredentialRepository: Sendable {
    func listEmails() async throws -> [AuthCredentialIdentityOption]
    func create(payload: AuthCredentialFormPayloadModel) async throws
}
