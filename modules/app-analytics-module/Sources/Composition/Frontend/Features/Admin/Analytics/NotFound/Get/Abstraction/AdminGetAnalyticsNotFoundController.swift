import FeatherAdmin
import Foundation
import Hummingbird

public protocol AdminGetAnalyticsNotFoundController: Sendable {

    func getNotFound(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetAnalyticsNotFoundController {

    public func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/analytics/not-found/",
            use: getNotFound
        )
    }
}
