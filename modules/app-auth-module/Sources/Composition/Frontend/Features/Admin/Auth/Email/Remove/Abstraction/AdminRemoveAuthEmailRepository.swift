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

protocol AdminRemoveAuthEmailRepository: Sendable {

    func get(
        id: String
    ) async throws -> AuthEmailDetailsModel

    func delete(
        id: String
    ) async throws
}
