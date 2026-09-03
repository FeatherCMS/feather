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

protocol AdminEditAuthEmailRepository: Sendable {

    func get(
        id: String
    ) async throws -> AuthEmailDetailsModel

    func update(
        id: String,
        payload: AuthEmailFormPayloadModel
    ) async throws
}
