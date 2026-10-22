import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Overview {
    enum Controller {
        protocol Interface: Sendable {
            func getOverview(
                request: Request,
                context: AuthenticatedRequestContext
            ) async throws -> HTMLResponse
        }
    }
}

extension Overview.Controller.Interface {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get("/admin/web/", use: getOverview)
    }
}
