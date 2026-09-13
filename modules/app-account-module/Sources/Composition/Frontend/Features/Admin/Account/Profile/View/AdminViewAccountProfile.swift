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

struct AdminViewAccountProfile {
    let controller: any AdminViewAccountProfileController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewAccountProfileDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewAccountProfileDefaultInteractor(
                        accountProfileRepository:
                            AdminViewAccountProfileOpenAPIRepository(
                                api: context.accountAppAPI(),
                                mediaAPI: context.mediaAdminAPI()
                            )
                    ),
                    presenter: AdminViewAccountProfileDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
