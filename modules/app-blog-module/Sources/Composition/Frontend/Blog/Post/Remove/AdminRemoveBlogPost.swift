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

struct AdminRemoveBlogPost {
    let controller: any AdminRemoveBlogPostController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveBlogPostDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveBlogPostDefaultInteractor(
                        repository: AdminRemoveBlogPostOpenAPIRepository(
                            api: context.blogAdminAPI()
                        )
                    ),
                    presenter: AdminRemoveBlogPostDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
