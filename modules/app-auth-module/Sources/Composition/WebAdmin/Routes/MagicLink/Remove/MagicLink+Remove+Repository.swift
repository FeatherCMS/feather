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

extension MagicLink.Remove {
    enum Repository {}
}

extension MagicLink.Remove.Repository {
    protocol Interface: Sendable {

        func delete(ids: [String]) async throws
    }
}
