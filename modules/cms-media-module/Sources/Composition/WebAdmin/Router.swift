import FeatherValidation
public import FeatherWebAdmin
public import FeatherWebShared
import HTML
public import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

public struct Router {
    public struct Routes: Sendable {
        public let admin: WebRoute
        public let root: WebRoute
        let breadcrumb: [AdminBreadcrumb.Link]
        let asset: Asset.Router.Routes
        let variant: Variant.Router.Routes
        let overview: Overview.View.Router.Routes

        public var assetList: WebRoute { asset.file.list }
        public var assetAdd: WebRoute { asset.file.add }
        public var variantList: WebRoute { variant.list }

        public init(
            admin: WebRoute = WebRoute.root.appending(pathComponent: "admin"),
            root: WebRoute = WebRoute.root
                .appending(pathComponent: "admin")
                .appending(pathComponent: "media")
        ) {
            self.admin = admin
            self.root = root
            self.breadcrumb = [
                .init(label: "Admin", link: admin.path),
                .init(label: "Media", link: root.path),
            ]
            self.asset = .init(root: root, breadcrumb: breadcrumb)
            self.variant = .init(root: root, breadcrumb: breadcrumb)
            self.overview = .init(
                root: root,
                breadcrumb: breadcrumb,
                assets: asset.file.list,
                variants: variant.list
            )
        }

        public static let standard = Routes()
    }

    private let environment: AppEnvironment
    private let renderingEngine: any RenderingEngine
    private let routes: Routes

    public init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        routes: Routes = .standard
    ) {
        self.environment = environment
        self.renderingEngine = renderingEngine
        self.routes = routes
    }

    public func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        Overview.View
            .Router(routes: routes.overview, renderingEngine: renderingEngine)
            .route(on: router)
        Asset.Router(
            routes: routes.asset,
            environment: environment,
            renderingEngine: renderingEngine
        )
        .route(on: router)
        Variant.Router(
            routes: routes.variant,
            environment: environment,
            renderingEngine: renderingEngine
        )
        .route(on: router)
    }
}
