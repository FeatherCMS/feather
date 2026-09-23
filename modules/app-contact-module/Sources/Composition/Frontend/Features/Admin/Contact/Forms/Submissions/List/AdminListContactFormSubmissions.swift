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

    init(apiBuilder: ContactAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminListContactFormSubmissionsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor:
                        AdminListContactFormSubmissionsDefaultInteractor(
                            repository: .init(
                                api: apiBuilder.makeContactAdmin(context)
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
