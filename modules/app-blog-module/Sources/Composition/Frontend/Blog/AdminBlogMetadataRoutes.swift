import FeatherAdmin
import Hummingbird
import WebFrontend

enum AdminBlogMetadataRoutes {
    static func register(
        router: Router<DefaultRequestContext>,
        renderingEngine: any RenderingEngine,
        events: any EventPublisher
    ) {
        for route in [
            (
                "/admin/blog/posts/{id}/edit/metadata/{metadataID}/",
                "blog.post"
            ),
            (
                "/admin/blog/authors/{id}/edit/metadata/{metadataID}/",
                "blog.author"
            ),
            (
                "/admin/blog/tags/{id}/edit/metadata/{metadataID}/",
                "blog.tag"
            ),
        ] {
            router.get(RouterPath(route.0)) { request, context in
                let handler = AdminWebMetadataEditHandler(
                    renderingEngine: renderingEngine,
                    adminEvents: events
                )
                return try await handler.get(
                    request: request,
                    context: context,
                    referenceType: route.1
                )
            }
            router.post(RouterPath(route.0)) { request, context in
                let handler = AdminWebMetadataEditHandler(
                    renderingEngine: renderingEngine,
                    adminEvents: events
                )
                return try await handler.post(
                    request: request,
                    context: context,
                    referenceType: route.1
                )
            }
        }
    }
}
