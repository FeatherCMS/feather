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

protocol AdminRemoveAuthCredentialRepository: Sendable {
    func get(id: String) async throws -> AuthCredentialDetailsModel
    func delete(id: String) async throws
}
