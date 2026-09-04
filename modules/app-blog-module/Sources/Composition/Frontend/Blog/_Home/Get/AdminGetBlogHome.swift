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

struct AdminGetBlogHome {
    let controller: any AdminGetBlogHomeController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetBlogHomeDefaultController(
            buildRuntime: { request, _ in
                (
                    interactor: AdminGetBlogHomeDefaultInteractor(),
                    presenter: AdminGetBlogHomeDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
