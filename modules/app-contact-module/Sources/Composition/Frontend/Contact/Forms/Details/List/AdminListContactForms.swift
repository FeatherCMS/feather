import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminListContactForms {
    let controller: any AdminListContactFormsController

    init(details: AdminContactFormDetails) {
        controller = AdminListContactFormsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListContactFormsDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminListContactFormsDefaultPresenter(
                        request: request,
                        renderEngine: details.renderingEngine
                    )
                )
            }
        )
    }

    func route(on router: Router<DefaultRequestContext>) {
        controller.route(on: router)
    }
}
