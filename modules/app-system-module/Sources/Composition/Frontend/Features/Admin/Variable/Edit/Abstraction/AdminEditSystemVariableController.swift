import FeatherAdmin
import HTML
import Hummingbird

protocol AdminEditSystemVariableController: Sendable {

    func getEditSystemVariable(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditSystemVariable(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminEditSystemVariableController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            SystemVariableRoutes.edit(RouterPath("{id}")),
            use: getEditSystemVariable
        )
        router.post(
            SystemVariableRoutes.edit(RouterPath("{id}")),
            use: postEditSystemVariable
        )
    }
}
