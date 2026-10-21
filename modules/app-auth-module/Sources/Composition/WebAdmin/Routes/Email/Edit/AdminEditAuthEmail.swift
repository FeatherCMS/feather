import AuthAdminAPI
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
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
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditAuthEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAuthEmailDefaultInteractor(
                        repository: AdminEditAuthEmailOpenAPIRepository(
                            api: API.Client(
                                environment: environment,
                                requestContext: context
                            ),
                            userAPI: UserWebAdmin.API.Client(
                                apiBaseURL: environment.apiBaseURL,
                                requestContext: context
                            )
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
