import FeatherAdmin
import Hummingbird

protocol AdminViewDesignSystemController: Sendable {

    func getDesignSystem(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewDesignSystemController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/system/design-system",
            use: getDesignSystem
        )
    }
}
