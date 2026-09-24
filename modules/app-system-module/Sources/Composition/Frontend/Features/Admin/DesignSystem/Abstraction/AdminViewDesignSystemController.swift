import FeatherAdmin
import Hummingbird

protocol AdminViewDesignSystemController: Sendable {

    func getDesignSystem(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewDesignSystemController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            "/admin/system/design-system",
            use: getDesignSystem
        )
    }
}
