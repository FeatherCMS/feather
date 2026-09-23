import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactForms {
    let controller: any AdminListContactFormsController

    init(apiBuilder: ContactAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminListContactFormsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListContactFormsDefaultInteractor(
                        repository: .init(api: apiBuilder.makeContactAdmin(context))
                    ),
                    presenter: AdminListContactFormsDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
