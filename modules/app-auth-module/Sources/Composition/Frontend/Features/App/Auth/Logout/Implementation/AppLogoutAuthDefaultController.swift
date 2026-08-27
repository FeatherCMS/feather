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

struct AppLogoutAuthDefaultController: AppLogoutAuthController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AppLogoutAuthInteractor,
            presenter: any AppLogoutAuthPresenter
        )

    func getLogout(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        if let sessionToken = context.sessionToken, !sessionToken.isEmpty {
            await interactor.execute(entity: .init(sessionToken: sessionToken))
        }

        return Response(
            status: .seeOther,
            headers: [
                .location: "/",
                .setCookie: presenter.expiredSessionCookie().description,
            ]
        )
    }
}
