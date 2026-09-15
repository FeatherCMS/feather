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
import WebBuilders
import WebComponents

struct AdminEditAccountProfile {
    let controller: any AdminEditAccountProfileController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditAccountProfileDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAccountProfileDefaultInteractor(
                        accountProfileRepository:
                            AdminEditAccountProfileOpenAPIRepository(
                                api: context.accountAppAPI(),
                                mediaAPI: context.mediaAdminAPI()
                            )
                    ),
                    presenter: AdminEditAccountProfileDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
