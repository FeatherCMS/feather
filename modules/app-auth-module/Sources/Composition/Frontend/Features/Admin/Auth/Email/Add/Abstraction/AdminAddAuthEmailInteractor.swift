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
import WebStandards

protocol AdminAddAuthEmailInteractor: Sendable {

    func listIdentities() async throws -> [AuthCredentialIdentityOption]

    func execute(
        entity: AdminAddAuthEmailModel
    ) async throws
}
