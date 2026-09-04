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

struct AdminRemoveBlogAuthorLink {
    let controller: any AdminRemoveBlogAuthorLinkController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveBlogAuthorLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveBlogAuthorLinkDefaultInteractor(
                        repository: AdminRemoveBlogAuthorLinkOpenAPIRepository(
                            api: context.blogAdminAPI()
                        )
                    ),
                    presenter: AdminRemoveBlogAuthorLinkDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
