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

protocol AdminEditAuthEmailRepository: Sendable {

    func listIdentities() async throws -> [AuthCredentialIdentityOption]

    func get(
        id: String
    ) async throws -> AuthEmailDetailsModel

    func update(
        id: String,
        payload: AuthEmailFormPayloadModel
    ) async throws
}
