import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactForm {
    let controller: any AdminEditContactFormController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditContactFormDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditContactFormDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminEditContactFormDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
