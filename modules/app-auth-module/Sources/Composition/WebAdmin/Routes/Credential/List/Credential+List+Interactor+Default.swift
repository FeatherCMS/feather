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

extension Credential.List.Interactor {
    struct Default: Interface {
        let repository: any Credential.List.Repository.Interface

        func execute(
            page: Int,
            size: Int,
            search: String?
        ) async throws -> (
            items: [AuthAdminAPI.Components.Schemas
                .AuthCredentialQueryItemSchema],
            total: Int,
            page: Int,
            size: Int
        ) {
            try await repository.list(
                page: page,
                size: size,
                search: search
            )
        }
    }
}
