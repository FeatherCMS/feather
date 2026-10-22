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
    enum Repository {}
}

extension Credential.List.Repository {
    protocol Interface: Sendable {
        func list(
            page: Int,
            size: Int,
            search: String?
        ) async throws -> (
            items: [AuthAdminAPI.Components.Schemas
                .AuthCredentialQueryItemSchema],
            total: Int,
            page: Int,
            size: Int
        )
    }
}
