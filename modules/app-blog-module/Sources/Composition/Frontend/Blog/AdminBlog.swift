import BlogAdminAPI
import BlogAppAPI
public import FeatherAdmin
public import FeatherContracts
import FeatherValidation
import HTML
public import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

public struct AdminBlog {
    private let apiBuilder: BlogAPIBuilder
    public let renderingEngine: any RenderingEngine
    public let adminEvents: any EventPublisher

    public init(
        apiBuilder: BlogAPIBuilder,
        renderingEngine: any RenderingEngine,
        adminEvents: any EventPublisher
    ) {
        self.apiBuilder = apiBuilder
        self.renderingEngine = renderingEngine
        self.adminEvents = adminEvents
    }

    public func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        AdminViewBlogOverview(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditBlogSettings(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListBlogPost(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewBlogPost(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddBlogPost(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditBlogPost(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveBlogPost(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListBlogAuthor(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewBlogAuthor(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddBlogAuthor(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditBlogAuthor(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveBlogAuthor(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListBlogAuthorLink(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewBlogAuthorLink(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddBlogAuthorLink(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditBlogAuthorLink(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveBlogAuthorLink(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListBlogTag(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewBlogTag(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddBlogTag(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditBlogTag(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveBlogTag(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminBlogMetadataRoutes.register(
            router: router,
            apiBuilder: apiBuilder.web,
            renderingEngine: renderingEngine,
            events: adminEvents
        )
    }
}
