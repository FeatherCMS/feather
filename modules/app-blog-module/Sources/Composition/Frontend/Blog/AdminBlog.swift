import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebApplication
import WebFrontend
import WebStandards

public struct AdminBlog {
    public let renderingEngine: any RenderingEngine
    public let templateOptions: [WebPageTemplateOption]

    public init(
        renderingEngine: any RenderingEngine,
        templateOptions: [WebPageTemplateOption] = []
    ) {
        self.renderingEngine = renderingEngine
        self.templateOptions = templateOptions
    }


    public func route(
        on router: Router<AppRequestContext>
    ) {
        AdminGetBlogHome(
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

        AdminGetBlogPost(
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

        AdminGetBlogAuthor(
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

        AdminGetBlogAuthorLink(
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

        AdminGetBlogTag(
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
            templateOptions: templateOptions
        )
    }
}
