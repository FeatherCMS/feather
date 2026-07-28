import Hummingbird

struct AppLogoutUserDefaultController: AppLogoutUserController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AppLogoutUserInteractor,
            presenter: any AppLogoutUserPresenter
        )

    func getLogout(
        request: Request,
        context: AppRequestContext
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
