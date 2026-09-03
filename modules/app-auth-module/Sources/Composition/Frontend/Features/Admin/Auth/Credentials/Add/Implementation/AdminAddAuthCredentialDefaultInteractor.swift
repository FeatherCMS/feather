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

struct AdminAddAuthCredentialDefaultInteractor: AdminAddAuthCredentialInteractor
{
    let repository: any AdminAddAuthCredentialRepository

    func listIdentities() async throws -> [AuthCredentialIdentityOption] {
        try await repository.listIdentities()
    }

    func execute(payload: AuthCredentialFormPayloadModel) async throws {
        try await repository.create(payload: payload)
    }
}
