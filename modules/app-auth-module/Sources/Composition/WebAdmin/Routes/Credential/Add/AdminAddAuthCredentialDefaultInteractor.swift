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

struct AdminAddAuthCredentialDefaultInteractor: AdminAddAuthCredentialInteractor
{
    let repository: any AdminAddAuthCredentialRepository

    func listEmails() async throws -> [AuthCredentialIdentityOption] {
        try await repository.listEmails()
    }

    func execute(payload: AuthCredentialFormPayloadModel) async throws {
        try await repository.create(payload: payload)
    }
}
