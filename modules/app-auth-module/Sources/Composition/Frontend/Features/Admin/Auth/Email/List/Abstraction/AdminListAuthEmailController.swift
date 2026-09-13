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
import WebBuilders
import WebComponents

protocol AdminListAuthEmailController: Sendable {

    func getAuthEmails(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getAuthEmailsRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postAuthEmailsRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminListAuthEmailController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            AuthEmailRoutes.list,
            use: getAuthEmails
        )
        router.get(
            AuthEmailRoutes.remove,
            use: getAuthEmailsRemoveConfirmation
        )
        router.post(
            AuthEmailRoutes.remove,
            use: postAuthEmailsRemove
        )
    }
}
