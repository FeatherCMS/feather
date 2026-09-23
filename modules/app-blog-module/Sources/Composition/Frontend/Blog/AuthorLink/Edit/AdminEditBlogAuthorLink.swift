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

struct AdminEditBlogAuthorLink {
    let controller: any AdminEditBlogAuthorLinkController

    init(apiBuilder: BlogAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminEditBlogAuthorLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditBlogAuthorLinkDefaultInteractor(
                        repository: AdminEditBlogAuthorLinkOpenAPIRepository(
                            api: apiBuilder.makeBlogAdmin(context)
                        )
                    ),
                    presenter: AdminEditBlogAuthorLinkDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
