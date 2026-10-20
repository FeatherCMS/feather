import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherWebAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

struct AdminEditAuthEmail {
    let controller: any AdminEditAuthEmailController

    init(
        apiBuilder: AuthAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditAuthEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAuthEmailDefaultInteractor(
                        repository: AdminEditAuthEmailOpenAPIRepository(
                            api: apiBuilder.makeAuthAdmin(context),
                            userAPI: apiBuilder.makeUserAdmin(context)
                        )
                    ),
                    presenter: AdminEditAuthEmailDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
