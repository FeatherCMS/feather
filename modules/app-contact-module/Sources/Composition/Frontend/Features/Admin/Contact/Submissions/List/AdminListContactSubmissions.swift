import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactSubmissions {
    let controller: any AdminListContactSubmissionsController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminListContactSubmissionsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListContactSubmissionsDefaultInteractor(
                        repository: .init(api: context.contactAdminAPI())
                    ),
                    presenter: AdminListContactSubmissionsDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
