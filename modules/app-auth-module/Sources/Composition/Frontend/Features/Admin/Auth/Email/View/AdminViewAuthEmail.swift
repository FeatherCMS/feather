import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebBuilders
import WebComponents

struct AdminViewAuthEmail {
    let controller: any AdminViewAuthEmailController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewAuthEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewAuthEmailDefaultInteractor(
                        repository: AdminViewAuthEmailOpenAPIRepository(
                            api: context.authAdminAPI()
                        )
                    ),
                    presenter: AdminViewAuthEmailDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
