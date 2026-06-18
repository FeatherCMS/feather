import Hummingbird

protocol AdminListSystemVariableController: Sendable {

    func getSystemVariables(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func getSystemVariablesBulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response

    func postSystemVariablesBulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminListSystemVariableController {

    func route(
        on router: Router<AppRequestContext>
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
