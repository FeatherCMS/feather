import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewContactForm {
    let controller: any AdminViewContactFormController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminViewContactFormDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewContactFormDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminViewContactFormDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
