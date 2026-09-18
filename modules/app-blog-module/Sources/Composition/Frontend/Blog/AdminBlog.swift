import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

public struct AdminBlog {
    public let renderingEngine: any RenderingEngine
    public let adminEvents: any EventPublisher

    public init(
        renderingEngine: any RenderingEngine,
        adminEvents: any EventPublisher
    ) {
        self.renderingEngine = renderingEngine
        self.adminEvents = adminEvents
    }

    public func route(
        on router: Router<DefaultRequestContext>
    ) {
        AdminViewBlogOverview(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditBlogSettings(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListBlogPost(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewBlogPost(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddBlogPost(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditBlogPost(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveBlogPost(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListBlogAuthor(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewBlogAuthor(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddBlogAuthor(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditBlogAuthor(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveBlogAuthor(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListBlogAuthorLink(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewBlogAuthorLink(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddBlogAuthorLink(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditBlogAuthorLink(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveBlogAuthorLink(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListBlogTag(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewBlogTag(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddBlogTag(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditBlogTag(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveBlogTag(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminBlogMetadataRoutes.register(
            router: router,
            renderingEngine: renderingEngine,
            events: adminEvents
        )
    }
}
