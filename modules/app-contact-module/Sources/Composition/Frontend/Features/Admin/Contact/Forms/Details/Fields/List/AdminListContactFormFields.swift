import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFormFields {
    let controller: any AdminListContactFormFieldsController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListContactFormFieldsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListContactFormFieldsDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminListContactFormFieldsDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }

}
