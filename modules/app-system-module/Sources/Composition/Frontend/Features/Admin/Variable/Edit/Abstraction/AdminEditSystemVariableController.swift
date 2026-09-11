import FeatherAdmin
import HTML
import Hummingbird

protocol AdminEditSystemVariableController: Sendable {

    func getEditSystemVariable(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postEditSystemVariable(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminEditSystemVariableController {

    func route(
        on router: Router<DefaultRequestContext>
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
