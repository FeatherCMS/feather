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

struct AdminEditAuthAccessControl {

    let controller: any AdminEditAuthAccessControlController

    init(apiBuilder: AuthAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditAuthAccessControlDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAuthAccessControlDefaultInteractor(
                        repository: AdminEditAuthAccessControlOpenAPIRepository(
                            api: apiBuilder.makeAuthAdmin(context),
                            userAPI: apiBuilder.makeUserAdmin(context),
                            systemAPI: apiBuilder.makeSystemAdmin(context)
                        )
                    ),
                    presenter: AdminEditAuthAccessControlDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
