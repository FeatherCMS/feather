import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
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

struct AdminListAuthMagicLinkDefaultInteractor: AdminListAuthMagicLinkInteractor
{
    let repository: any AdminListAuthMagicLinkRepository

    func execute(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [AuthAdminAPI.Components.Schemas.AuthMagicLinkListItemSchema],
        total: Int,
        page: Int, size: Int
    ) {
        try await repository.list(
            page: page,
            size: size,
            search: search
        )
    }

    func bulkRemove(
        ids: [String]
    ) async throws {
        for id in ids {
            try await repository.delete(id: id)
        }
    }
}
