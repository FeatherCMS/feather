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

struct AdminGetBlogTag {
    let controller: any AdminGetBlogTagController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetBlogTagDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetBlogTagDefaultInteractor(
                        repository: AdminGetBlogTagOpenAPIRepository(
                            api: context.blogAdminAPI()
                        )
                    ),
                    presenter: AdminGetBlogTagDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
