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

struct AdminViewAuthOverviewDefaultInteractor: AdminViewAuthOverviewInteractor {
    func getOverview() async throws -> AdminViewAuthOverviewModel {
        .init(title: "Auth module")
    }
}
