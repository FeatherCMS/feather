import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddContactFormEmail {
    let controller: any AdminAddContactFormEmailController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminAddContactFormEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddContactFormEmailDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminAddContactFormEmailDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
