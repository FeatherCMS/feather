import FeatherAdmin
import Hummingbird
import WebApplication
import WebFrontend

enum AdminBlogMetadataRoutes {
    static func register(
        router: Router<AppRequestContext>,
        renderingEngine: any RenderingEngine,
        templateOptions: [WebPageTemplateOption]
    ) {
        let handler = AdminWebMetadataEditHandler(
            renderingEngine: renderingEngine,
            templateOptions: templateOptions
        )
        for route in [
            (
                "/admin/blog/posts/{contentID}/edit/metadata/{metadataID}/",
                "blog.post"
            ),
            (
                "/admin/blog/authors/{contentID}/edit/metadata/{metadataID}/",
                "blog.author"
            ),
            (
                "/admin/blog/tags/{contentID}/edit/metadata/{metadataID}/",
                "blog.tag"
            ),
        ] {
            router.get(RouterPath(route.0)) { request, context in
                try await handler.get(
                    request: request,
                    context: context,
                    referenceType: route.1
                )
            }
            router.post(RouterPath(route.0)) { request, context in
                try await handler.post(
                    request: request,
                    context: context,
                    referenceType: route.1
                )
            }
        }
    }
}
