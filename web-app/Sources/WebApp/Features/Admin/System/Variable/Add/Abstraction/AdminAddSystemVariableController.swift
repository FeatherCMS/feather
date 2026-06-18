import HTML
import Hummingbird

protocol AdminAddSystemVariableController: Sendable {

    func getAddSystemVariable(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postAddSystemVariable(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminAddSystemVariableController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/system/variables/add/",
            use: getAddSystemVariable
        )
        router.post(
            "/admin/system/variables/add/",
            use: postAddSystemVariable
        )
    }
}
