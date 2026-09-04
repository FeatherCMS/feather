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

struct AdminListBlogAuthorLink {
    let controller: any AdminListBlogAuthorLinkController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListBlogAuthorLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListBlogAuthorLinkDefaultInteractor(
                        repository: AdminListBlogAuthorLinkOpenAPIRepository(
                            api: context.blogAdminAPI()
                        )
                    ),
                    presenter: AdminListBlogAuthorLinkDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
