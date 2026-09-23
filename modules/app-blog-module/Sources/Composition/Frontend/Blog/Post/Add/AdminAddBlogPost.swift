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

struct AdminAddBlogPost {
    let controller: any AdminAddBlogPostController

    init(apiBuilder: BlogAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminAddBlogPostDefaultController(
            apiBuilder: apiBuilder,
            buildRuntime: { request, context in
                (
                    interactor: AdminAddBlogPostDefaultInteractor(
                        repository: AdminAddBlogPostOpenAPIRepository(
                            api: apiBuilder.makeBlogAdmin(context)
                        ),
                        optionRepository:
                            AdminAddBlogPostOptionOpenAPIRepository(
                                api: apiBuilder.makeBlogAdmin(context)
                            )
                    ),
                    presenter: AdminAddBlogPostDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
