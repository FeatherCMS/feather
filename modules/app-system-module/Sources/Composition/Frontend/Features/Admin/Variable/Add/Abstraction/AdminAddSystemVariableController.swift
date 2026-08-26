import FeatherAdmin
import HTML
import Hummingbird

protocol AdminAddSystemVariableController: Sendable {

    func getAddSystemVariable(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postAddSystemVariable(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminAddSystemVariableController {

    func route(
        on router: Router<DefaultRequestContext>
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
