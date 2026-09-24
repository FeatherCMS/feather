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

struct AdminEditBlogPost {
    let controller: any AdminEditBlogPostController

    init(
        apiBuilder: BlogAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditBlogPostDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditBlogPostDefaultInteractor(
                        repository: AdminEditBlogPostOpenAPIRepository(
                            api: apiBuilder.makeBlogAdmin(context)
                        ),
                        optionRepository:
                            AdminEditBlogPostOptionOpenAPIRepository(
                                api: apiBuilder.makeBlogAdmin(context)
                            )
                    ),
                    presenter: AdminEditBlogPostDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
