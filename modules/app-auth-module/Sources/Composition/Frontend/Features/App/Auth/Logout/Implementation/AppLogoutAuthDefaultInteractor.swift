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
import WebComponents
import WebBuilders

struct AppLogoutAuthDefaultInteractor: AppLogoutAuthInteractor {
    private let repository: any AppLogoutAuthRepository

    init(repository: any AppLogoutAuthRepository) {
        self.repository = repository
    }

    func execute(
        entity: AppLogoutAuthModel
    ) async {
        try? await repository.logout(sessionToken: entity.sessionToken)
    }
}
