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
import WebBuilders
import WebComponents

protocol AdminEditAccountProfileController: Sendable {

    func getEditAccountProfile(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditAccountProfile(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditAccountProfileController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/account/profile/edit/",
            use: getEditAccountProfile
        )
        router.post(
            "/admin/account/profile/edit/",
            use: postEditAccountProfile
        )
    }
}
