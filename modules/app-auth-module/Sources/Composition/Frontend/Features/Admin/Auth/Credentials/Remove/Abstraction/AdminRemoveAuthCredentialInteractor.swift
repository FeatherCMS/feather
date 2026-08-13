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

protocol AdminRemoveAuthCredentialInteractor: Sendable {
    func get(id: String) async throws -> AuthCredentialDetailsModel
    func delete(id: String) async throws
}
