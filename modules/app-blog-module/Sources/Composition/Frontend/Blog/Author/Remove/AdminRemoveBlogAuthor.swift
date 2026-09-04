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

struct AdminRemoveBlogAuthor {
    let controller: any AdminRemoveBlogAuthorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveBlogAuthorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveBlogAuthorDefaultInteractor(
                        repository: AdminRemoveBlogAuthorOpenAPIRepository(
                            api: context.blogAdminAPI()
                        )
                    ),
                    presenter: AdminRemoveBlogAuthorDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
