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

extension MagicLink.Add.Interactor {
    struct Default: Interface {
        let repository: any MagicLink.Add.Repository.Interface

        func listEmails() async throws
            -> [Email.Option]
        {
            try await repository.listEmails()
        }

        func execute(
            entity: MagicLink.Add.Model
        ) async throws {
            try await repository.create(payload: entity.payload)
        }
    }
}
