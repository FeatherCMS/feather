import FeatherAdmin
import Hummingbird

protocol AdminListSystemVariableController: Sendable {

    func getSystemVariables(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getSystemVariablesBulkRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postSystemVariablesBulkRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminListSystemVariableController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/system/variables",
            use: getSystemVariables
        )
        router.get(
            "/admin/system/variables/bulk-remove/",
            use: getSystemVariablesBulkRemoveConfirmation
        )
        router.post(
            "/admin/system/variables/bulk-remove/",
            use: postSystemVariablesBulkRemove
        )
    }
}
