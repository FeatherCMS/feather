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
            "/admin/system/variables/{id}/edit/",
            use: getEditSystemVariable
        )
        router.post(
            "/admin/system/variables/{id}/edit/",
            use: postEditSystemVariable
        )
    }
}
