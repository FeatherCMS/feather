import FeatherAdmin
import Hummingbird

protocol AdminListSystemVariableController: Sendable {

    func getSystemVariables(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

}

extension AdminListSystemVariableController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            SystemVariableRoutes.list,
            use: getSystemVariables
        )
    }
}
