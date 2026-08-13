import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminListContactFormFields {
    let controller: any AdminListContactFormFieldsController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListContactFormFieldsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListContactFormFieldsDefaultInteractor(
                        repository: .init(api: context.contactManagementAPI())
                    ),
                    presenter: AdminListContactFormFieldsDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }

}
