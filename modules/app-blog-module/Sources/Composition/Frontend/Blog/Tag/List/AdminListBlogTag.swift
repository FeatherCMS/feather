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

struct AdminListBlogTag {
    let controller: any AdminListBlogTagController

    init(
        apiBuilder: BlogAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminListBlogTagDefaultController(
            apiBuilder: apiBuilder,
            buildRuntime: { request, context in
                (
                    interactor: AdminListBlogTagDefaultInteractor(
                        repository: AdminListBlogTagOpenAPIRepository(
                            api: apiBuilder.makeBlogAdmin(context)
                        )
                    ),
                    presenter: AdminListBlogTagDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
