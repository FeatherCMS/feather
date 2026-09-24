import FeatherAdmin
import HTML
import Hummingbird

protocol AdminAddSystemVariableController: Sendable {

    func getAddSystemVariable(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddSystemVariable(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminAddSystemVariableController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            SystemVariableRoutes.add,
            use: getAddSystemVariable
        )
        router.post(
            SystemVariableRoutes.add,
            use: postAddSystemVariable
        )
    }
}
