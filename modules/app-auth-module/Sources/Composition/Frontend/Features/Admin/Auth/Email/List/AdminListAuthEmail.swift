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

struct AdminListAuthEmail {
    let controller: any AdminListAuthEmailController

    init(apiBuilder: AuthAPIBuilder,
        renderingEngine: any RenderingEngine) {
        self.controller = AdminListAuthEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListAuthEmailDefaultInteractor(
                        repository: AdminListAuthEmailOpenAPIRepository(
                            api: apiBuilder.makeAuthAdmin(context),
                            userAPI: apiBuilder.makeUserAdmin(context)
                        )
                    ),
                    presenter: AdminListAuthEmailDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
