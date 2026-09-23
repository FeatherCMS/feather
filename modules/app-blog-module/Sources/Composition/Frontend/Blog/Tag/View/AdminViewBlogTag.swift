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

struct AdminViewBlogTag {
    let controller: any AdminViewBlogTagController

    init(apiBuilder: BlogAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminViewBlogTagDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewBlogTagDefaultInteractor(
                        repository: AdminViewBlogTagOpenAPIRepository(
                            api: apiBuilder.makeBlogAdmin(context)
                        )
                    ),
                    presenter: AdminViewBlogTagDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
