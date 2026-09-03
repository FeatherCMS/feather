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

struct AdminRemoveAuthEmailDefaultInteractor:
    AdminRemoveAuthEmailInteractor
{
    let repository: any AdminRemoveAuthEmailRepository

    func get(
        id: String
    ) async throws -> AuthEmailDetailsModel {
        try await repository.get(id: id)
    }

    func execute(
        entity: AdminRemoveAuthEmailModel
    ) async throws {
        try await repository.delete(id: entity.id)
    }
}
