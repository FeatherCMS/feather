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

protocol AdminEditAuthProfileController: Sendable {

    func getEditAuthProfile(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditAuthProfile(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditAuthProfileController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/auth/profile/edit/",
            use: getEditAuthProfile
        )
        router.post(
            "/admin/auth/profile/edit/",
            use: postEditAuthProfile
        )
    }
}
