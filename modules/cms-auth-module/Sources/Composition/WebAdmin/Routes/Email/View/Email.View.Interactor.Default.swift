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

extension Email.View.Interactor {
    struct Default: Interface {
        let repository: any Email.View.Repository.Interface

        func execute(
            entity: Email.View.Model
        ) async throws -> Email.View.Detail {
            try await repository.get(id: entity.id)
        }
    }
}
