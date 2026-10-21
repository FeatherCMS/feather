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

struct AdminRemoveAuthMagicLinkDefaultInteractor:
    AdminRemoveAuthMagicLinkInteractor
{
    let repository: any AdminRemoveAuthMagicLinkRepository

    func remove(ids: [String]) async throws {
        try await repository.delete(ids: ids)
    }
}
