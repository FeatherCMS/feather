import FeatherAdmin
import Hummingbird
import WebContracts
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
