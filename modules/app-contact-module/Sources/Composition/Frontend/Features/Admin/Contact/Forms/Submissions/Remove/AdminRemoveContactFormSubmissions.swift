import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactFormSubmissions {
    let controller: any AdminRemoveContactFormSubmissionsController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminRemoveContactFormSubmissionsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor:
                        AdminRemoveContactFormSubmissionsDefaultInteractor(
                            repository: .init(
                                api: context.contactAdminAPI()
                            )
                        ),
                    presenter:
                        AdminRemoveContactFormSubmissionsDefaultPresenter(
                            request: request,
                        context: context,
                        renderingEngine: renderingEngine
                        )
                )
            }
        )
    }
}
