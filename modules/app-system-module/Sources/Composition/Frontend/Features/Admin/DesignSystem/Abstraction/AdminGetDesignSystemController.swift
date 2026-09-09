import FeatherAdmin
import Hummingbird

protocol AdminGetDesignSystemController: Sendable {

    func getDesignSystem(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetDesignSystemController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/design-system",
            use: getDesignSystem
        )
    }
}
