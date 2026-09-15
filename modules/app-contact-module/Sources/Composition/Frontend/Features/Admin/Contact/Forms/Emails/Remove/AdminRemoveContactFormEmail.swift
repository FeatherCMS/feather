import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactFormEmail {
    let controller: any AdminRemoveContactFormEmailController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveContactFormEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveContactFormEmailDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminRemoveContactFormEmailDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
