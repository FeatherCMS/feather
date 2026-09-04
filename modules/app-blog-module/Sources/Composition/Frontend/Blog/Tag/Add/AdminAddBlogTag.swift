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

struct AdminAddBlogTag {
    let controller: any AdminAddBlogTagController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddBlogTagDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddBlogTagDefaultInteractor(
                        repository: AdminAddBlogTagOpenAPIRepository(
                            api: context.blogAdminAPI()
                        )
                    ),
                    presenter: AdminAddBlogTagDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
