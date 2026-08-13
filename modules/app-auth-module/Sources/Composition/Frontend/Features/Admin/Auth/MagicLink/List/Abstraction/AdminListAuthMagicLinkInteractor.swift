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

protocol AdminListAuthMagicLinkInteractor: Sendable {

    func execute(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [AuthAdminAPI.Components.Schemas.AuthMagicLinkListItemSchema],
        total: Int,
        page: Int,
        size: Int
    )

    func bulkRemove(
        ids: [String]
    ) async throws
}
