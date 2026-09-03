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

struct AdminAddAuthEmailDefaultInteractor: AdminAddAuthEmailInteractor {
    let repository: any AdminAddAuthEmailRepository

    func listIdentities() async throws -> [AuthCredentialIdentityOption] {
        try await repository.listIdentities()
    }

    func execute(
        entity: AdminAddAuthEmailModel
    ) async throws {
        try await repository.create(payload: entity.payload)
    }
}
