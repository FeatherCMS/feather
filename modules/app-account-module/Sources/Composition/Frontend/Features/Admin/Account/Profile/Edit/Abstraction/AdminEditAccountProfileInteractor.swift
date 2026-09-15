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
import WebBuilders
import WebComponents

protocol AdminEditAccountProfileInteractor: Sendable {

    func loadProfile(
        account: AccountModel
    ) async throws -> AdminEditAccountProfileModel

    func execute(
        entity: AdminEditAccountProfileModel
    ) async throws
}
