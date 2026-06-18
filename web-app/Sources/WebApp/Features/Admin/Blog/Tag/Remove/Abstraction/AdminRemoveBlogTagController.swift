import HTML
import Hummingbird

protocol AdminRemoveBlogTagController: Sendable {

    func getRemoveBlogTag(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveBlogTag(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveBlogTagController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/blog/tags/{id}/remove/",
            use: getRemoveBlogTag
        )
        router.post(
            "/admin/blog/tags/{id}/remove/",
            use: postRemoveBlogTag
        )
    }
}
