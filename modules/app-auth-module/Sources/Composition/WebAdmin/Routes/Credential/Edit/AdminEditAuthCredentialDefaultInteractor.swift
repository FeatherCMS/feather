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

struct AdminEditAuthCredentialDefaultInteractor:
    AdminEditAuthCredentialInteractor
{
    let repository: any AdminEditAuthCredentialRepository

    func listEmails() async throws -> [AuthAdminAPI.Components.Schemas
        .AuthEmailDetailSchema]
    {
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
