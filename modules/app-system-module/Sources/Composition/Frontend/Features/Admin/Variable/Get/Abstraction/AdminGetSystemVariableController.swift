import FeatherAdmin
import Hummingbird

protocol AdminGetSystemVariableController: Sendable {

    func getSystemVariable(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetSystemVariableController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/system/variables/{id}/",
            use: getSystemVariable
        )
    }
}
