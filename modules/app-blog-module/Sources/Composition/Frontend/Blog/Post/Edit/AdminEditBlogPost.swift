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

struct AdminEditBlogPost {
    let controller: any AdminEditBlogPostController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditBlogPostDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditBlogPostDefaultInteractor(
                        repository: AdminEditBlogPostOpenAPIRepository(
                            api: context.blogAdminAPI()
                        ),
                        optionRepository:
                            AdminEditBlogPostOptionOpenAPIRepository(
                                api: context.blogAdminAPI()
                            )
                    ),
                    presenter: AdminEditBlogPostDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
