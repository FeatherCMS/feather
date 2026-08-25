import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import SystemFrontend

struct AdminAddWebMenuItem {
    let controller: any AdminAddWebMenuItemController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddWebMenuItemDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddWebMenuItemDefaultInteractor(
                        repository: AdminAddWebMenuItemOpenAPIRepository(
                            api: context.webManagementAPI()
                        )
                    ),
                    presenter: AdminAddWebMenuItemDefaultPresenter(
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
