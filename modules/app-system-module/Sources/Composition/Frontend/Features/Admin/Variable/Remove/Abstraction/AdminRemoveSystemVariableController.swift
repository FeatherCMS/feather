import SystemModule
import FeatherAdmin
import HTML
import Hummingbird

protocol AdminRemoveSystemVariableController: Sendable {

    func postRemoveSystemVariables(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveSystemVariableController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.post(
            SystemVariableRoutes.remove,
            use: postRemoveSystemVariables
        )
    }
}
