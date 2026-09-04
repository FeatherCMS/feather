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
import WebComponents
import WebBuilders

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
