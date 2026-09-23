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

struct AdminRemoveBlogAuthor {
    let controller: any AdminRemoveBlogAuthorController

    init(apiBuilder: BlogAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveBlogAuthorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveBlogAuthorDefaultInteractor(
                        repository: AdminRemoveBlogAuthorOpenAPIRepository(
                            api: apiBuilder.makeBlogAdmin(context)
                        )
                    ),
                    presenter: AdminRemoveBlogAuthorDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
