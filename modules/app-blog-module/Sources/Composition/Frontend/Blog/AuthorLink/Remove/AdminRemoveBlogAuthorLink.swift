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

struct AdminRemoveBlogAuthorLink {
    let controller: any AdminRemoveBlogAuthorLinkController

    init(
        apiBuilder: BlogAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminRemoveBlogAuthorLinkDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveBlogAuthorLinkDefaultInteractor(
                        repository: AdminRemoveBlogAuthorLinkOpenAPIRepository(
                            api: apiBuilder.makeBlogAdmin(context)
                        )
                    ),
                    presenter: AdminRemoveBlogAuthorLinkDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
