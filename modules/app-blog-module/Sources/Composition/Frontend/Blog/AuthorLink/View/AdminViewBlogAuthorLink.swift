import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct AdminViewBlogAuthorLink {
    let controller: any AdminViewBlogAuthorLinkController

    init(apiBuilder: BlogAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminViewBlogAuthorLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewBlogAuthorLinkDefaultInteractor(
                        repository: AdminViewBlogAuthorLinkOpenAPIRepository(
                            api: apiBuilder.makeBlogAdmin(context)
                        )
                    ),
                    presenter: AdminViewBlogAuthorLinkDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
