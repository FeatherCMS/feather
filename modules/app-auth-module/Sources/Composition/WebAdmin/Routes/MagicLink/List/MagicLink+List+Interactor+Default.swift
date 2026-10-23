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

extension MagicLink.List.Interactor {
    struct Default: Interface {
        let repository: any MagicLink.List.Repository.Interface

        func execute(
            page: Int,
            size: Int,
            search: String?,
            userID: String?
        ) async throws -> MagicLink.List.Result {
            try await repository.list(
                page: page,
                size: size,
                search: search,
                userID: userID
            )
        }

    }
}
