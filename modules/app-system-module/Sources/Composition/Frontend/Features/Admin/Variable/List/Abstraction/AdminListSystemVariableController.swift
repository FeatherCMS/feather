import FeatherAdmin
import Hummingbird

protocol AdminListSystemVariableController: Sendable {

    func getSystemVariables(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

}

extension AdminListSystemVariableController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            SystemVariableRoutes.list,
            use: getSystemVariables
        )
    }
}
