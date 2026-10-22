import FeatherWebApp
import FeatherWebShared
import Hummingbird

extension Logout.Controller {
    struct Default: Interface {
        let buildRuntime:
            RuntimeBuilder<
                any Logout.Interactor.Interface,
                any Logout.Presenter.Interface
            >

        func getLogout(
            request: Request,
            context: DefaultRequestContext
        ) async throws -> Response {
            let (interactor, presenter) = buildRuntime((request, context))
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
