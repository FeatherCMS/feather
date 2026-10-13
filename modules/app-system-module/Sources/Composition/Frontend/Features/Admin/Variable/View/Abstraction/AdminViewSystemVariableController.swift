import FeatherAdmin
import Hummingbird

protocol AdminViewSystemVariableController: Sendable {

    func getSystemVariable(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewSystemVariableController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            SystemVariableRoutes.details(RouterPath("{id}")),
            use: getSystemVariable
        )
    }
}
