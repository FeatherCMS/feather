import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebComponents
import WebBuilders

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
