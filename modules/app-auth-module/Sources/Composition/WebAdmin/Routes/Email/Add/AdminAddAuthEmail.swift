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

struct AdminAddAuthEmail {
    let controller: any AdminAddAuthEmailController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminAddAuthEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddAuthEmailDefaultInteractor(
                        repository: AdminAddAuthEmailOpenAPIRepository(
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
