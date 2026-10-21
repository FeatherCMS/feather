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

protocol AdminEditAuthCredentialInteractor: Sendable {
    func get(id: String) async throws -> AuthCredentialDetailsModel
    func listEmails() async throws -> [AuthAdminAPI.Components.Schemas
        .AuthEmailDetailSchema]
    func execute(id: String, payload: AuthCredentialFormPayloadModel)
        async throws
}
