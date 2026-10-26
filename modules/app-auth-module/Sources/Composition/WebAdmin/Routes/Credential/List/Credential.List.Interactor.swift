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

extension Credential.List {
    enum Interactor {}
}

extension Credential.List.Interactor {
    protocol Interface: Sendable {
        func execute(
            page: Int,
            size: Int,
            search: String?
        ) async throws -> Credential.List.Result
    }
}
