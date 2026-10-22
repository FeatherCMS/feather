import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebModuleWebAdmin

enum AdminBlogMetadataRoutes {
    private struct Route: Sendable {
        let path: RouterPath
        let referenceType: String
        let title: String
        let breadcrumb: [AdminBreadcrumb.Link]
        let editPath: @Sendable (RouterPath) -> RouterPath
    }

    static func register(
        router: any RouterMethods<AuthenticatedRequestContext>,
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        events: any EventPublisher,
        routes: BlogWebAdmin.Router.Routes
    ) {
        let apiBuilder = WebModuleWebAdmin.API.Builder(environment: environment)
        let routes = [
            Route(
                path: routes.postEditMetadataRoute(),
                referenceType: "blog.post",
                title: "Edit post metadata",
                breadcrumb: routes.postsBreadcrumb,
                editPath: routes.postEdit
            ),
            Route(
                path: routes.authorEditMetadataRoute(),
                referenceType: "blog.author",
                title: "Edit author metadata",
                breadcrumb: routes.authorsBreadcrumb,
                editPath: routes.authorEdit
            ),
            Route(
                path: routes.tagEditMetadataRoute(),
                referenceType: "blog.tag",
                title: "Edit tag metadata",
                breadcrumb: routes.tagsBreadcrumb,
                editPath: routes.tagEdit
            ),
        ]

        for route in routes {
            router.get(route.path) { request, context in
                let id = try context.requiredID()
                let metadataID =
                    context.parameters.get("metadataID", as: String.self) ?? ""
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
                            href: editPath.appendingPath(RouterPath("metadata"))
                                .appendingPath(RouterPath(metadataID))
                                .description + "/",
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

            router.post(route.path) { request, context in
                let id = try context.requiredID()
                let metadataID =
                    context.parameters.get("metadataID", as: String.self) ?? ""
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
                            href: editPath.appendingPath(RouterPath("metadata"))
                                .appendingPath(RouterPath(metadataID))
                                .description + "/",
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
