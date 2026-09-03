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

struct AdminEditAuthCredentialDefaultInteractor:
    AdminEditAuthCredentialInteractor
{
    let repository: any AdminEditAuthCredentialRepository

    func listEmails() async throws -> [AuthAdminAPI.Components.Schemas.AuthEmailDetailSchema] {
        try await repository.listEmails()
    }

    func get(id: String) async throws -> AuthCredentialDetailsModel {
        try await repository.get(id: id)
    }

    func execute(id: String, payload: AuthCredentialFormPayloadModel)
        async throws
    {
        try await repository.update(id: id, payload: payload)
    }
}
