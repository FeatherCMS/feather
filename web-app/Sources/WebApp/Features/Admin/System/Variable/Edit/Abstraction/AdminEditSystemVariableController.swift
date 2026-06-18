import HTML
import Hummingbird

protocol AdminEditSystemVariableController: Sendable {

    func getEditSystemVariable(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditSystemVariable(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditSystemVariableController {

    func route(
        on router: Router<AppRequestContext>
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
