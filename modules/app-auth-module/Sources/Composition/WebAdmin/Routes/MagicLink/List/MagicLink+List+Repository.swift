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

extension MagicLink.List {
    enum Repository {}
}

extension MagicLink.List.Repository {
    protocol Interface: Sendable {

        func list(
            page: Int,
            size: Int,
            search: String?,
            userID: String?
        ) async throws -> MagicLink.List.Result

    }
}
