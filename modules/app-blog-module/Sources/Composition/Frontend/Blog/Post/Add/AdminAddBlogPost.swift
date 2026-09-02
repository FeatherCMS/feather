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

struct AdminAddBlogPost {
    let controller: any AdminAddBlogPostController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddBlogPostDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddBlogPostDefaultInteractor(
                        repository: AdminAddBlogPostOpenAPIRepository(
                            api: context.blogAdminAPI()
                        ),
                        optionRepository:
                            AdminAddBlogPostOptionOpenAPIRepository(
                                api: context.blogAdminAPI()
                            )
                    ),
                    presenter: AdminAddBlogPostDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
