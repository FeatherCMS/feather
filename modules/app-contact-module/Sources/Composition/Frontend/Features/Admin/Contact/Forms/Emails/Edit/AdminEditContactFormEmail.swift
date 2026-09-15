import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactFormEmail {
    let controller: any AdminEditContactFormEmailController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditContactFormEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditContactFormEmailDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminEditContactFormEmailDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
