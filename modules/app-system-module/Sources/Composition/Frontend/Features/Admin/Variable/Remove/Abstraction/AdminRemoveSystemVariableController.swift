import FeatherAdmin
import HTML
import Hummingbird

protocol AdminRemoveSystemVariableController: Sendable {

    func getRemoveSystemVariables(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postRemoveSystemVariables(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminRemoveSystemVariableController {

    func route(
        on router: Router<DefaultRequestContext>
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
