import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactFormSubmission {
    let controller: any AdminEditContactFormSubmissionController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminEditContactFormSubmissionDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditContactFormSubmissionDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminEditContactFormSubmissionDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
