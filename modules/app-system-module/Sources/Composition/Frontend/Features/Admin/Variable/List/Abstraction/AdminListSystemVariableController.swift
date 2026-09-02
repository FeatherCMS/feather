import FeatherAdmin
import Hummingbird

protocol AdminListSystemVariableController: Sendable {

    func getSystemVariables(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getSystemVariablesRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postSystemVariablesRemove(
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
            "/admin/system/variables/remove/",
            use: getSystemVariablesRemoveConfirmation
        )
        router.post(
            "/admin/system/variables/remove/",
            use: postSystemVariablesRemove
        )
    }
}
