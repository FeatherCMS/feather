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

struct AdminEditBlogAuthorLink {
    let controller: any AdminEditBlogAuthorLinkController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditBlogAuthorLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditBlogAuthorLinkDefaultInteractor(
                        repository: AdminEditBlogAuthorLinkOpenAPIRepository(
                            api: context.blogManagementAPI()
                        )
                    ),
                    presenter: AdminEditBlogAuthorLinkDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
