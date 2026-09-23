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

    init(apiBuilder: ContactAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminEditContactFormEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditContactFormEmailDefaultInteractor(
                        repository: .init(api: apiBuilder.makeContactAdmin(context))
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
