import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactFormField {
    let controller: any AdminRemoveContactFormFieldController

    init(apiBuilder: ContactAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminRemoveContactFormFieldDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveContactFormFieldDefaultInteractor(
                        repository: .init(api: apiBuilder.makeContactAdmin(context))
                    ),
                    presenter: AdminRemoveContactFormFieldDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
