import FeatherAdmin
import FeatherContracts
import Hummingbird
import WebFrontend

enum AdminBlogMetadataRoutes {
    private struct Route: Sendable {
        let path: String
        let referenceType: String
        let title: String
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let editPath: @Sendable (RouterPath) -> RouterPath
    }

    static func register(
        router: any RouterMethods<AuthenticatedRequestContext>,
        apiBuilder: WebAPIBuilder,
        renderingEngine: any RenderingEngine,
        events: any EventPublisher
    ) {
        let routes = [
            Route(
                path: "/admin/blog/posts/{id}/edit/metadata/{metadataID}/",
                referenceType: "blog.post",
                title: "Edit post metadata",
                breadcrumb: BlogAdminRoutes.postsBreadcrumb,
                editPath: BlogAdminRoutes.postEdit
            ),
            Route(
                path: "/admin/blog/authors/{id}/edit/metadata/{metadataID}/",
                referenceType: "blog.author",
                title: "Edit author metadata",
                breadcrumb: BlogAdminRoutes.authorsBreadcrumb,
                editPath: BlogAdminRoutes.authorEdit
            ),
            Route(
                path: "/admin/blog/tags/{id}/edit/metadata/{metadataID}/",
                referenceType: "blog.tag",
                title: "Edit tag metadata",
                breadcrumb: BlogAdminRoutes.tagsBreadcrumb,
                editPath: BlogAdminRoutes.tagEdit
            ),
        ]

        for route in routes {
            router.get(RouterPath(route.path)) { request, context in
                let id = try context.requiredID()
                let metadataID =
                    context.parameters.get(
                        "metadataID",
                        as: String.self
                    ) ?? ""
                let editPath = route.editPath(RouterPath(id))
                let configuration = AdminWebMetadataEditConfiguration(
                    referenceType: route.referenceType,
                    title: route.title,
                    description: "Update the metadata for this blog content.",
                    breadcrumb: route.breadcrumb,
                    navigationTabs: [
                        .init(
                            label: "Details",
                            href: editPath.description + "/",
                            isCurrent: false
                        ),
                        .init(
                            label: "Metadata",
                            href:
                                editPath.appendingPath(
                                    RouterPath("metadata")
                                )
                                .appendingPath(RouterPath(metadataID))
                                .description
                                + "/",
                            isCurrent: true
                        ),
                    ]
                )
                let handler = AdminWebMetadataEditHandler(
                    apiBuilder: apiBuilder,
                    renderingEngine: renderingEngine,
                    adminEvents: events
                )
                return try await handler.get(
                    request: request,
                    context: context,
                    configuration: configuration
                )
            }
            router.post(RouterPath(route.path)) { request, context in
                let id = try context.requiredID()
                let metadataID =
                    context.parameters.get(
                        "metadataID",
                        as: String.self
                    ) ?? ""
                let editPath = route.editPath(RouterPath(id))
                let configuration = AdminWebMetadataEditConfiguration(
                    referenceType: route.referenceType,
                    title: route.title,
                    description: "Update the metadata for this blog content.",
                    breadcrumb: route.breadcrumb,
                    navigationTabs: [
                        .init(
                            label: "Details",
                            href: editPath.description + "/",
                            isCurrent: false
                        ),
                        .init(
                            label: "Metadata",
                            href:
                                editPath.appendingPath(
                                    RouterPath("metadata")
                                )
                                .appendingPath(RouterPath(metadataID))
                                .description
                                + "/",
                            isCurrent: true
                        ),
                    ]
                )
                let handler = AdminWebMetadataEditHandler(
                    apiBuilder: apiBuilder,
                    renderingEngine: renderingEngine,
                    adminEvents: events
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
