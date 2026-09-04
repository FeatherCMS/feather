import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebComponents
import WebBuilders

struct AdminGetBlogAuthorLink {
    let controller: any AdminGetBlogAuthorLinkController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetBlogAuthorLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetBlogAuthorLinkDefaultInteractor(
                        repository: AdminGetBlogAuthorLinkOpenAPIRepository(
                            api: context.blogAdminAPI()
                        )
                    ),
                    presenter: AdminGetBlogAuthorLinkDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
