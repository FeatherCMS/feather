import BlogModule
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebModuleWebAdmin

enum AdminBlogMetadataRoutes {
    private struct Route: Sendable {
        let path: WebRoute
        let referenceType: String
        let title: String
        let breadcrumb: [AdminBreadcrumb.Link]
        let editPath: @Sendable (String) -> String
        let metadataPath: @Sendable (String, String) -> String
    }

    static func register(
        router: any RouterMethods<AuthenticatedRequestContext>,
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        events: any EventPublisher,
        postRoutes: Post.Router.Routes,
        authorRoutes: Author.Router.Routes,
        tagRoutes: Tag.Router.Routes
    ) {
        let apiBuilder = WebModuleWebAdmin.API.Builder(environment: environment)
        let routes = [
            Route(
                path: postRoutes.postEditMetadataRoute(),
                referenceType: "blog.post",
                title: "Edit post metadata",
                breadcrumb: postRoutes.postsBreadcrumb,
                editPath: postRoutes.postEdit,
                metadataPath: postRoutes.postEditMetadata
            ),
            Route(
                path: authorRoutes.authorEditMetadataRoute(),
                referenceType: "blog.author",
                title: "Edit author metadata",
                breadcrumb: authorRoutes.authorsBreadcrumb,
                editPath: authorRoutes.authorEdit,
                metadataPath: authorRoutes.authorEditMetadata
            ),
            Route(
                path: tagRoutes.tagEditMetadataRoute(),
                referenceType: "blog.tag",
                title: "Edit tag metadata",
                breadcrumb: tagRoutes.tagsBreadcrumb,
                editPath: tagRoutes.tagEdit,
                metadataPath: tagRoutes.tagEditMetadata
            ),
        ]

        for route in routes {
            router.get(route.path.routerPath) { request, context in
                let id = try context.requiredID()
                let metadataID =
                    context.parameters.get("metadataID", as: String.self) ?? ""
                let editPath = route.editPath(id)
                let configuration = AdminWebMetadataEditConfiguration(
                    referenceType: route.referenceType,
                    title: route.title,
                    description: "Update the metadata for this blog content.",
                    breadcrumb: route.breadcrumb,
                    navigationTabs: [
                        .init(
                            label: "Details",
                            href: editPath,
                            isCurrent: false
                        ),
                        .init(
                            label: "Metadata",
                            href: route.metadataPath(id, metadataID),
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

            router.post(route.path.routerPath) { request, context in
                let id = try context.requiredID()
                let metadataID =
                    context.parameters.get("metadataID", as: String.self) ?? ""
                let editPath = route.editPath(id)
                let configuration = AdminWebMetadataEditConfiguration(
                    referenceType: route.referenceType,
                    title: route.title,
                    description: "Update the metadata for this blog content.",
                    breadcrumb: route.breadcrumb,
                    navigationTabs: [
                        .init(
                            label: "Details",
                            href: editPath,
                            isCurrent: false
                        ),
                        .init(
                            label: "Metadata",
                            href: route.metadataPath(id, metadataID),
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
