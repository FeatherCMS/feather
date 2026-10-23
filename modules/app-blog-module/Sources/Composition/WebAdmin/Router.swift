import BlogAdminAPI
import BlogAppAPI
import BlogModule
public import FeatherModuleKit
import FeatherValidation
public import FeatherWebAdmin
public import FeatherWebShared
import HTML
public import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import WebBuilders
import WebComponents

public struct Router {
    private let environment: AppEnvironment
    private let routes: Routes
    public let renderingEngine: any RenderingEngine
    public let adminEvents: any EventPublisher

    public init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine,
        adminEvents: any EventPublisher,
        routes: Routes = .standard
    ) {
        self.environment = environment
        self.routes = routes
        self.renderingEngine = renderingEngine
        self.adminEvents = adminEvents
    }

    public func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        Overview.Router(
            renderingEngine: renderingEngine,
            routes: Overview.Router.Routes(
                root: routes.blog,
                breadcrumb: routes.breadcrumb
            )
        )
        .route(on: router)

        Settings.Edit
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.settings
            )
            .route(on: router)

        Post.List
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.post
            )
            .route(on: router)

        Post.Status.Router(environment: environment, routes: routes.post)
            .route(on: router)

        Post.View
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.post
            )
            .route(on: router)

        Post.Add
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.post
            )
            .route(on: router)

        Post.Edit
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.post
            )
            .route(on: router)

        Post.Remove
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.post
            )
            .route(on: router)

        Author.List
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.author
            )
            .route(on: router)

        Author.View
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.author,
                authorLinkRoutes: routes.authorLink
            )
            .route(on: router)

        Author.Add
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.author
            )
            .route(on: router)

        Author.Edit
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.author
            )
            .route(on: router)

        Author.Remove
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.author
            )
            .route(on: router)

        AuthorLink.List
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.authorLink
            )
            .route(on: router)

        AuthorLink.View
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.authorLink
            )
            .route(on: router)

        AuthorLink.Add
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.authorLink
            )
            .route(on: router)

        AuthorLink.Edit
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.authorLink
            )
            .route(on: router)

        AuthorLink.Remove
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.authorLink
            )
            .route(on: router)

        Tag.List
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.tag
            )
            .route(on: router)

        Tag.View
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.tag
            )
            .route(on: router)

        Tag.Add
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.tag
            )
            .route(on: router)

        Tag.Edit
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.tag
            )
            .route(on: router)

        Tag.Remove
            .Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes.tag
            )
            .route(on: router)

        BlogMetadataRouter.register(
            router: router,
            environment: environment,
            renderingEngine: renderingEngine,
            events: adminEvents,
            postRoutes: routes.post,
            authorRoutes: routes.author,
            tagRoutes: routes.tag
        )
    }
}
