import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminGetContactForm {
    let controller: any AdminGetContactFormController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminGetContactFormDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetContactFormDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminGetContactFormDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
