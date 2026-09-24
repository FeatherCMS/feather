import FeatherAdmin
import HTML
import Hummingbird

protocol AdminRemoveSystemVariableController: Sendable {

    func getRemoveSystemVariables(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

    func postRemoveSystemVariables(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveSystemVariableController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            SystemVariableRoutes.remove,
            use: getRemoveSystemVariables
        )
        router.post(
            SystemVariableRoutes.remove,
            use: postRemoveSystemVariables
        )
    }
}
