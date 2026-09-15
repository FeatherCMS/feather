import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFormSubmissions {
    let controller: any AdminListContactFormSubmissionsController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListContactFormSubmissionsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor:
                        AdminListContactFormSubmissionsDefaultInteractor(
                            repository: .init(
                                api: context.contactAdminAPI()
                            )
                        ),
                    presenter: AdminListContactFormSubmissionsDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
