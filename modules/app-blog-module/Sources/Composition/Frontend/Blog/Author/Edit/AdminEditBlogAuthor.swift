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

struct AdminEditBlogAuthor {
    let controller: any AdminEditBlogAuthorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditBlogAuthorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditBlogAuthorDefaultInteractor(
                        repository: AdminEditBlogAuthorOpenAPIRepository(
                            api: context.blogAdminAPI()
                        )
                    ),
                    presenter: AdminEditBlogAuthorDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
