import FeatherAdmin
import FeatherContracts
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
                path: "/admin/blog/posts/{id}/edit/metadata/{metadataID}/",
                referenceType: "blog.post",
                title: "Edit post",
                breadcrumb: BlogAdminRoutes.postsBreadcrumb,
                detailsPath: "/admin/blog/posts/"
            ),
            (
                path: "/admin/blog/authors/{id}/edit/metadata/{metadataID}/",
                referenceType: "blog.author",
                title: "Edit author",
                breadcrumb: BlogAdminRoutes.authorsBreadcrumb,
                detailsPath: "/admin/blog/authors/"
            ),
            (
                path: "/admin/blog/tags/{id}/edit/metadata/{metadataID}/",
                referenceType: "blog.tag",
                title: "Edit tag",
                breadcrumb: BlogAdminRoutes.tagsBreadcrumb,
                detailsPath: "/admin/blog/tags/"
            ),
        ] {
            router.get(RouterPath(route.path)) { request, context in
                let handler = AdminWebMetadataEditHandler(
                    renderingEngine: renderingEngine,
                    adminEvents: events
                )
                let id = try context.requiredID()
                let configuration = AdminWebMetadataEditConfiguration(
                    referenceType: route.referenceType,
                    title: route.title,
                    breadcrumb: route.breadcrumb,
                    navigationTabs: [
                        .init(
                            label: "Details",
                            href: route.detailsPath + id + "/edit/",
                            isCurrent: false
                        ),
                        .init(
                            label: "Metadata",
                            href: request.uri.path,
                            isCurrent: true
                        ),
                    ]
                )
                return try await handler.get(
                    request: request,
                    context: context,
                    configuration: configuration
                )
            }
            router.post(RouterPath(route.path)) { request, context in
                let handler = AdminWebMetadataEditHandler(
                    renderingEngine: renderingEngine,
                    adminEvents: events
                )
                let id = try context.requiredID()
                let configuration = AdminWebMetadataEditConfiguration(
                    referenceType: route.referenceType,
                    title: route.title,
                    breadcrumb: route.breadcrumb,
                    navigationTabs: [
                        .init(
                            label: "Details",
                            href: route.detailsPath + id + "/edit/",
                            isCurrent: false
                        ),
                        .init(
                            label: "Metadata",
                            href: request.uri.path,
                            isCurrent: true
                        ),
                    ]
                )
                return try await handler.post(
                    request: request,
                    context: context,
                    configuration: configuration
                )
            }
        }
    }
}
