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

struct AdminAddAuthEmail {
    let controller: any AdminAddAuthEmailController

    init(apiBuilder: AuthAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminAddAuthEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddAuthEmailDefaultInteractor(
                        repository: AdminAddAuthEmailOpenAPIRepository(
                            api: apiBuilder.makeAuthAdmin(context),
                            userAPI: apiBuilder.makeUserAdmin(context)
                        )
                    ),
                    presenter: AdminAddAuthEmailDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
