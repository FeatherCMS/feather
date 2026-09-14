import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactForm {
    let controller: any AdminRemoveContactFormController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveContactFormDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveContactFormDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminRemoveContactFormDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
