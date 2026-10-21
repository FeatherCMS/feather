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

protocol AdminEditAuthMagicLinkInteractor: Sendable {

    func listEmails() async throws -> [AuthAdminAPI.Components.Schemas
        .AuthEmailDetailSchema]

    func get(
        id: String
    ) async throws -> AuthMagicLinkDetailsModel

    func execute(
        entity: AdminEditAuthMagicLinkModel
    ) async throws
}
