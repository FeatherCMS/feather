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

struct AdminAddAuthEmail {
    let controller: any AdminAddAuthEmailController

    init(
        apiBuilder: AuthAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
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
