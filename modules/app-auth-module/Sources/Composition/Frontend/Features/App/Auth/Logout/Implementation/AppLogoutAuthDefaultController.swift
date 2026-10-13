import FeatherAdmin
import Hummingbird

struct AppLogoutAuthDefaultController: AppLogoutAuthController {
    let buildRuntime:
        RuntimeBuilder<
            any AppLogoutAuthInteractor,
            any AppLogoutAuthPresenter
        >

    func getLogout(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
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
