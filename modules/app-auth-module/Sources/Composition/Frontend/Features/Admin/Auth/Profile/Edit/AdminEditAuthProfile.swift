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

struct AdminEditAuthProfile {
    let controller: any AdminEditAuthProfileController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditAuthProfileDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAuthProfileDefaultInteractor(
                        accountProfileRepository:
                            AdminAuthAccountProfileOpenAPIRepository(
                                api: context.accountAppAPI(),
                                mediaAPI: context.mediaAdminAPI()
                            )
                    ),
                    presenter: AdminEditAuthProfileDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
