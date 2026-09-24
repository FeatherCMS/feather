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

struct AdminAddBlogTag {
    let controller: any AdminAddBlogTagController

    init(
        apiBuilder: BlogAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminAddBlogTagDefaultController(
            apiBuilder: apiBuilder,
            buildRuntime: { request, context in
                (
                    interactor: AdminAddBlogTagDefaultInteractor(
                        repository: AdminAddBlogTagOpenAPIRepository(
                            api: apiBuilder.makeBlogAdmin(context)
                        )
                    ),
                    presenter: AdminAddBlogTagDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
