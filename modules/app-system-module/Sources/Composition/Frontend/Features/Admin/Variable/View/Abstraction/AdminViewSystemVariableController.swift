import FeatherAdmin
import Hummingbird

protocol AdminViewSystemVariableController: Sendable {

    func getSystemVariable(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewSystemVariableController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            SystemVariableRoutes.details(RouterPath("{id}")),
            use: getSystemVariable
        )
    }
}
