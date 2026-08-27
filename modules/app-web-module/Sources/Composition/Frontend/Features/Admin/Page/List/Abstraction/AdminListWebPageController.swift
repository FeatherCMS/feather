import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminListWebPageController: Sendable {

    func getWebPages(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func getWebPagesBulkRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postWebPagesBulkRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response

    func postWebPageStatus(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminListWebPageController {

    func route(
        on router: Router<DefaultRequestContext>
    ) {
        router.get(
            "/admin/web/pages",
            use: getWebPages
        )
        router.get(
            "/admin/web/pages/bulk-remove/",
            use: getWebPagesBulkRemoveConfirmation
        )
        router.post(
            "/admin/web/pages/bulk-remove/",
            use: postWebPagesBulkRemove
        )
        router.post(
            "/admin/web/pages/{id}/status/",
            use: postWebPageStatus
        )
    }
}
