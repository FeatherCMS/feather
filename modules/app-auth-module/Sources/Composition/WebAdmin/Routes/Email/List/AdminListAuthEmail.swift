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

struct AdminListAuthEmail {
    let controller: any AdminListAuthEmailController

    init(
        environment: AppEnvironment,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminListAuthEmailDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListAuthEmailDefaultInteractor(
                        repository: AdminListAuthEmailOpenAPIRepository(
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
                    presenter: AdminListAuthEmailDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
