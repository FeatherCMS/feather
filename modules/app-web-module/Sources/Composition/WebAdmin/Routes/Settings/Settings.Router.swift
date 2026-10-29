import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import WebDomain
import WebModule

extension Settings {
    struct Router {
        struct Routes: Sendable {
            let edit: WebRoute
            let homePageLookup: WebRoute
            let breadcrumb: [AdminBreadcrumb.Link]
            let mediaAssetList: WebRoute

            init(
                edit: WebRoute,
                breadcrumb: [AdminBreadcrumb.Link],
                mediaAssetList: WebRoute
            ) {
                self.edit = edit
                self.homePageLookup = edit.appending(pathComponent: "home-page-lookup")
                self.mediaAssetList = mediaAssetList
                self.breadcrumb =
                    breadcrumb + [
                        .init(label: "Settings", link: edit.path)
                    ]
            }
        }

        let environment: AppEnvironment
        let renderingEngine: any RenderingEngine
        let routes: Routes

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            Edit
                .Router(
                    environment: environment,
                    renderingEngine: renderingEngine,
                    routes: routes
                )
                .route(on: router)
        }
    }
}
