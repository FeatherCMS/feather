import AuthAdminAPI
import AuthModule
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

extension Email.Remove.Interactor {
    struct Default: Interface {
        let repository: any Email.Remove.Repository.Interface

        func get(
            id: String
        ) async throws -> Email.View.Detail {
            try await repository.get(id: id)
        }

        func execute(
            entity: Email.Remove.Model
        ) async throws {
            try await repository.delete(id: entity.id)
        }

        func remove(
            ids: [String]
        ) async throws {
            for id in ids {
                try await repository.delete(id: id)
            }
        }
    }
}
