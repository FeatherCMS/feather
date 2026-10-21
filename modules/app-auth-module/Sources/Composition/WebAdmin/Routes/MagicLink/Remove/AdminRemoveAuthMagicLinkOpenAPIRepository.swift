import AuthAdminAPI
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

struct AdminRemoveAuthMagicLinkOpenAPIRepository:
    AdminRemoveAuthMagicLinkRepository
{
    let api: API.Client

    func delete(ids: [String]) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.authMagicLinkRemove(
                body: .json(.init(ids: ids))
            )
        }
    }
}
