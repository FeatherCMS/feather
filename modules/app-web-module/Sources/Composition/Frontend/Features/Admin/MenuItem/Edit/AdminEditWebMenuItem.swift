import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import SystemFrontend

struct AdminEditWebMenuItem {
    let controller: any AdminEditWebMenuItemController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebMenuItemDefaultInteractor(
                        repository: AdminEditWebMenuItemOpenAPIRepository(
                            api: context.webManagementAPI()
                        )
                    ),
                    presenter: AdminEditWebMenuItemDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            },
            loadPermissions: { context in
                try await AdminSystemPermissionOpenAPIRepository(
                    api: context.systemManagementAPI()
                )
                .listNames()
            }
        )
    }
}
