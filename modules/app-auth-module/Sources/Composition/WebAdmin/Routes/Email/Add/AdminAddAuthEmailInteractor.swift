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

protocol AdminAddAuthEmailInteractor: Sendable {

    func listIdentities() async throws -> [AuthCredentialIdentityOption]

    func execute(
        entity: AdminAddAuthEmailModel
    ) async throws
}
