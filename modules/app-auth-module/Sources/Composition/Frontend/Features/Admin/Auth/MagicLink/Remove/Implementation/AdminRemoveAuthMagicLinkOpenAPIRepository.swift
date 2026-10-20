import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherWebAdmin
import FeatherValidation
import FeatherValidationFoundation
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
    let api: AuthAdminAPIClient

    func delete(ids: [String]) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.authMagicLinkRemove(
                body: .json(.init(ids: ids))
            )
        }
    }
}
