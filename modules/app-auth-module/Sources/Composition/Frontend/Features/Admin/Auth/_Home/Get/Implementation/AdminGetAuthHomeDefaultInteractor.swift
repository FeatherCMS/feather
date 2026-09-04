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
import WebComponents
import WebBuilders

struct AdminGetAuthHomeDefaultInteractor: AdminGetAuthHomeInteractor {
    func getHome() async throws -> AdminGetAuthHomeModel {
        .init(title: "Auth module")
    }
}
