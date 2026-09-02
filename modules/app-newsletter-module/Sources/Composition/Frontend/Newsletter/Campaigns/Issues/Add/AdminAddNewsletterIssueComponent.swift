import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddNewsletterIssueComponent {
    let controller: any AdminAddNewsletterIssueController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminAddNewsletterIssueDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddNewsletterIssueDefaultInteractor(
                        repository:
                            AdminAddNewsletterIssueOpenAPIRepository(
                                api: context.newsletterAdminAPI()
                            )
                    ),
                    presenter: AdminAddNewsletterIssueDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
