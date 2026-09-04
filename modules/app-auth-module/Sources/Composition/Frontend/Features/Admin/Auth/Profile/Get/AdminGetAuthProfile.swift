import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebComponents
import WebBuilders

struct AdminGetAuthProfile {
    let controller: any AdminGetAuthProfileController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetAuthProfileDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetAuthProfileDefaultInteractor(
                        accountProfileRepository:
                            AdminAuthAccountProfileOpenAPIRepository(
                                api: context.accountAppAPI(),
                                mediaAPI: context.mediaAdminAPI()
                            )
                    ),
                    presenter: AdminGetAuthProfileDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
