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
import WebStandards

struct AdminAddBlogAuthorLink {
    let controller: any AdminAddBlogAuthorLinkController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddBlogAuthorLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddBlogAuthorLinkDefaultInteractor(
                        repository: AdminAddBlogAuthorLinkOpenAPIRepository(
                            api: context.blogAdminAPI()
                        )
                    ),
                    presenter: AdminAddBlogAuthorLinkDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
