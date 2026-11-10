import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsModule
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
            articleRoutes: Article.Router.Routes,
            categoryRoutes: Category.Router.Routes
        ) {
            let routes = [
                Route(
                    path: articleRoutes.editMetadataRoute(),
                    referenceType: "news.article",
                    title: "Edit article metadata",
                    breadcrumb: articleRoutes.breadcrumb,
                    mediaAssetList: articleRoutes.mediaAssetList,
                    editPath: articleRoutes.editPath,
                    metadataPath: articleRoutes.editMetadataPath
                ),
                Route(
                    path: categoryRoutes.editMetadataRoute(),
                    referenceType: "news.category",
                    title: "Edit category metadata",
                    breadcrumb: categoryRoutes.breadcrumb,
                    mediaAssetList: categoryRoutes.mediaAssetList,
                    editPath: categoryRoutes.editPath,
                    metadataPath: categoryRoutes.editMetadataPath
                ),
            ]

            for route in routes {
                router.get(route.path.routerPath) { request, context in
                    let id = try context.requiredID()
                    let metadataID = context.parameters.get(
                        "metadataID",
                        as: String.self
                    ) ?? ""
                    let configuration = WebModule.Metadata.Edit.Configuration(
                        referenceType: route.referenceType,
                        title: route.title,
                        description: "Update the metadata for this news content.",
                        breadcrumb: route.breadcrumb,
                        navigationTabs: [
                            .init(
                                label: "Details",
                                href: route.editPath(id),
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
                    let metadataID = context.parameters.get(
                        "metadataID",
                        as: String.self
                    ) ?? ""
                    let configuration = WebModule.Metadata.Edit.Configuration(
                        referenceType: route.referenceType,
                        title: route.title,
                        description: "Update the metadata for this news content.",
                        breadcrumb: route.breadcrumb,
                        navigationTabs: [
                            .init(
                                label: "Details",
                                href: route.editPath(id),
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
