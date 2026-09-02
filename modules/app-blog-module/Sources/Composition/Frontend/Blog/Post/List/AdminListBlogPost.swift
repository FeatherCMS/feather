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

struct AdminListBlogPost {
    let controller: any AdminListBlogPostController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListBlogPostDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListBlogPostDefaultInteractor(
                        repository: AdminListBlogPostOpenAPIRepository(
                            api: context.blogAdminAPI()
                        )
                    ),
                    presenter: AdminListBlogPostDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
