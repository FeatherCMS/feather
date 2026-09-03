import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
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

struct AdminEditAuthEmailDefaultInteractor: AdminEditAuthEmailInteractor {
    let repository: any AdminEditAuthEmailRepository

    func listIdentities() async throws -> [AuthCredentialIdentityOption] {
        try await repository.listIdentities()
    }

    func get(
        id: String
    ) async throws -> AuthEmailDetailsModel {
        try await repository.get(id: id)
    }

    func execute(
        entity: AdminEditAuthEmailModel
    ) async throws {
        try await repository.update(
            id: entity.id,
            payload: entity.payload
        )
    }
}
