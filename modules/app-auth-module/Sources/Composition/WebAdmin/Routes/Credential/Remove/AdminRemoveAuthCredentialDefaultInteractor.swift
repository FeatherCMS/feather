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
