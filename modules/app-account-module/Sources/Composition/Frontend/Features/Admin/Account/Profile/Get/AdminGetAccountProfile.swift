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

struct AdminGetAccountProfile {
    let controller: any AdminGetAccountProfileController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetAccountProfileDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetAccountProfileDefaultInteractor(
                        accountProfileRepository:
                            AdminGetAccountProfileOpenAPIRepository(
                                api: context.accountAppAPI(),
                                mediaAPI: context.mediaAdminAPI()
                            )
                    ),
                    presenter: AdminGetAccountProfileDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
