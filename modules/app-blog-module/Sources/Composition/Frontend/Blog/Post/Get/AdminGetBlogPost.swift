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

struct AdminGetBlogPost {
    let controller: any AdminGetBlogPostController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetBlogPostDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetBlogPostDefaultInteractor(
                        repository: AdminGetBlogPostOpenAPIRepository(
                            api: context.blogAdminAPI()
                        )
                    ),
                    presenter: AdminGetBlogPostDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
