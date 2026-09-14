import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminGetContactFormSubmission {
    let controller: any AdminGetContactFormSubmissionController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminGetContactFormSubmissionDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetContactFormSubmissionDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminGetContactFormSubmissionDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
