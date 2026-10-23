import FeatherWebApp
import FeatherWebShared
import Hummingbird

extension Logout.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, DefaultRequestContext) -> WebAppRuntime<
                any Logout.Interactor.Interface,
                any Logout.Presenter.Interface
            >

        func getLogout(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response {
            let __runtimeBuild1 = buildRuntime(request, context)
            let interactor = __runtimeBuild1.interactor
            let presenter = __runtimeBuild1.presenter
            if let sessionToken = context.sessionToken, !sessionToken.isEmpty {
                await interactor.execute(
                    entity: .init(sessionToken: sessionToken)
                )
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
}
