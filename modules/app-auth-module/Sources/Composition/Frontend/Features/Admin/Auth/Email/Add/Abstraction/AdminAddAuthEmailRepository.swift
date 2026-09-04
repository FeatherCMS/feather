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

protocol AdminAddAuthEmailRepository: Sendable {

    func listIdentities() async throws -> [AuthCredentialIdentityOption]

    func create(
        payload: AuthEmailFormPayloadModel
    ) async throws
}
