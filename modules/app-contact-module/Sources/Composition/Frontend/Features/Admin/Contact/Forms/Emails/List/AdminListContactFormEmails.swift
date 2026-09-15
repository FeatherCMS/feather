import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFormEmails {
    let controller: any AdminListContactFormEmailsController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListContactFormEmailsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListContactFormEmailsDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminListContactFormEmailsDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
