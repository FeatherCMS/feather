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

struct AdminViewBlogPost {
    let controller: any AdminViewBlogPostController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewBlogPostDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewBlogPostDefaultInteractor(
                        repository: AdminViewBlogPostOpenAPIRepository(
                            api: context.blogAdminAPI()
                        )
                    ),
                    presenter: AdminViewBlogPostDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
