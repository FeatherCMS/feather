import FeatherAdmin
import Foundation
import Hummingbird

public protocol AdminGetAnalyticsNotFoundController: Sendable {

    func getNotFound(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetAnalyticsNotFoundController {

    public func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/analytics/not-found/",
            use: getNotFound
        )
    }
}
