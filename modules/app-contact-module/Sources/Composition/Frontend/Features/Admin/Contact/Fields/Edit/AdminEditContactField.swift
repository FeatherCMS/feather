import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactField {
    let controller: any AdminEditContactFieldController

    init(apiBuilder: ContactAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminEditContactFieldDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditContactFieldDefaultInteractor(
                        repository: .init(api: apiBuilder.makeContactAdmin(context))
                    ),
                    presenter: AdminEditContactFieldDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
