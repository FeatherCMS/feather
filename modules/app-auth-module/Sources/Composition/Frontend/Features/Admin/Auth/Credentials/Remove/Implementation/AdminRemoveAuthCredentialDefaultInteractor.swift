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

struct AdminRemoveAuthCredentialDefaultInteractor:
    AdminRemoveAuthCredentialInteractor
{
    let repository: any AdminRemoveAuthCredentialRepository

    func get(id: String) async throws -> AuthCredentialDetailsModel {
        try await repository.get(id: id)
    }

    func delete(id: String) async throws {
        try await repository.delete(id: id)
    }
}
