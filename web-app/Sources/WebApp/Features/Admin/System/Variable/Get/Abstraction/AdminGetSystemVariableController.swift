import Hummingbird

protocol AdminGetSystemVariableController: Sendable {

    func getSystemVariable(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetSystemVariableController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/system/variables/{id}/",
            use: getSystemVariable
        )
    }
}
