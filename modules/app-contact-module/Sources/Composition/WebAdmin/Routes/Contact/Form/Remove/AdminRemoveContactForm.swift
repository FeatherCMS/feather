import FeatherWebShared
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactForm {
    let controller: any AdminRemoveContactFormController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminRemoveContactFormDefaultController(
            buildRuntime: { request, context in
                WebAdminRuntime(
                    interactor: AdminRemoveContactFormDefaultInteractor(
                        repository: .init(
                            api: API.Client(
                                apiBaseURL: environment.apiBaseURL,
                                requestContext: context
                            )
                        )
                    ),
                    presenter: AdminRemoveContactFormDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
