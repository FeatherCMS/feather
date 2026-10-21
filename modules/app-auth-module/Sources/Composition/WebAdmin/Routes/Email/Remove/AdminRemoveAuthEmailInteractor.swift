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

protocol AdminRemoveAuthEmailInteractor: Sendable {

    func get(
        id: String
    ) async throws -> AuthEmailDetailsModel

    func execute(
        entity: AdminRemoveAuthEmailModel
    ) async throws

    func remove(
        ids: [String]
    ) async throws
}
