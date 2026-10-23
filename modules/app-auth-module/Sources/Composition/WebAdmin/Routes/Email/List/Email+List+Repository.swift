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

extension Email.List {
    enum Repository {}
}

extension Email.List.Repository {
    protocol Interface: Sendable {

        func list(
            page: Int,
            size: Int,
            search: String?,
            userID: String?
        ) async throws -> Email.List.Result

    }
}
