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

struct AdminViewBlogAuthor {
    let controller: any AdminViewBlogAuthorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewBlogAuthorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewBlogAuthorDefaultInteractor(
                        repository: AdminViewBlogAuthorOpenAPIRepository(
                            api: context.blogAdminAPI()
                        )
                    ),
                    presenter: AdminViewBlogAuthorDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
