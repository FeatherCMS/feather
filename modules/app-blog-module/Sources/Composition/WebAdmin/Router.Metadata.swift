import BlogModule
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebModule
import WebModuleWebAdmin

extension Router {
    enum Metadata {
        private struct Route: Sendable {
            let path: WebRoute
            let referenceType: String
            let title: String
            let breadcrumb: [AdminBreadcrumb.Link]
            let mediaAssetList: WebRoute
            let editPath: @Sendable (String) -> String
            let metadataPath: @Sendable (String, String) -> String
        }

        static func register(
            router: any RouterMethods<AuthenticatedRequestContext>,
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            events: any EventPublisher,
            postRoutes: Post.Routes,
            authorRoutes: Author.Routes,
            tagRoutes: Tag.Routes
        ) {
            let routes = [
                Route(
                    path: postRoutes.postEditMetadataRoute(),
                    referenceType: "blog.post",
                    title: "Edit post metadata",
                    breadcrumb: postRoutes.postsBreadcrumb,
                    mediaAssetList: postRoutes.mediaAssetList,
                    editPath: postRoutes.postEdit,
                    metadataPath: postRoutes.postEditMetadata
                ),
                Route(
                    path: authorRoutes.authorEditMetadataRoute(),
                    referenceType: "blog.author",
                    title: "Edit author metadata",
                    breadcrumb: authorRoutes.authorsBreadcrumb,
                    mediaAssetList: authorRoutes.mediaAssetList,
                    editPath: authorRoutes.authorEdit,
                    metadataPath: authorRoutes.authorEditMetadata
                ),
                Route(
                    path: tagRoutes.tagEditMetadataRoute(),
                    referenceType: "blog.tag",
                    title: "Edit tag metadata",
                    breadcrumb: tagRoutes.tagsBreadcrumb,
                    mediaAssetList: tagRoutes.mediaAssetList,
                    editPath: tagRoutes.tagEdit,
                    metadataPath: tagRoutes.tagEditMetadata
                ),
            ]

            for route in routes {
                router.get(route.path.routerPath) { request, context in
                    let id = try context.requiredID()
                    let metadataID =
                        context.parameters.get("metadataID", as: String.self)
                        ?? ""
                    let editPath = route.editPath(id)
                    let configuration = WebModule.Metadata.Edit.Configuration(
                        referenceType: route.referenceType,
                        title: route.title,
                        description:
                            "Update the metadata for this blog content.",
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
                    let handler = WebModule.Metadata.Edit.Handler(
                        environment: environment,
                        renderingEngine: renderingEngine,
                        adminEvents: events,
                        mediaAssetList: route.mediaAssetList
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
                        context.parameters.get("metadataID", as: String.self)
                        ?? ""
                    let editPath = route.editPath(id)
                    let configuration = WebModule.Metadata.Edit.Configuration(
                        referenceType: route.referenceType,
                        title: route.title,
                        description:
                            "Update the metadata for this blog content.",
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
                    let handler = WebModule.Metadata.Edit.Handler(
                        environment: environment,
                        renderingEngine: renderingEngine,
                        adminEvents: events,
                        mediaAssetList: route.mediaAssetList
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
}
