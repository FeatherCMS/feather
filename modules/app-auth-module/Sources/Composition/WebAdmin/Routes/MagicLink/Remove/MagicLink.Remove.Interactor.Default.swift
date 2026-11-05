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

extension MagicLink.Remove.Interactor {
    struct Default: Interface {
        let repository: any MagicLink.Remove.Repository.Interface

        func remove(ids: [String]) async throws {
            try await repository.delete(ids: ids)
        }
    }
}
