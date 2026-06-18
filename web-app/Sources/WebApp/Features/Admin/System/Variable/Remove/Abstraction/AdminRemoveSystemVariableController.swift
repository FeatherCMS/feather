import HTML
import Hummingbird

protocol AdminRemoveSystemVariableController: Sendable {

    func getRemoveSystemVariable(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveSystemVariable(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveSystemVariableController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/system/variables/{id}/remove/",
            use: getRemoveSystemVariable
        )
        router.post(
            "/admin/system/variables/{id}/remove/",
            use: postRemoveSystemVariable
        )
    }
}
