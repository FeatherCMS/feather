import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebStandards

struct AdminListAuthCredentialIdentityDefaultInteractor:
    AdminListAuthCredentialIdentityInteractor
{
    let repository: any AdminListAuthCredentialIdentityRepository

    func execute(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [UserAdminAPI.Components.Schemas.UserIdentityListItemSchema],
        total: Int,
        page: Int,
        size: Int
    ) {
        try await repository.list(page: page, size: size, search: search)
    }
}
