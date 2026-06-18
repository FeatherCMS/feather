import Hummingbird

struct AdminGetHome {
    let controller: any AdminGetHomeController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetHomeDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetHomeDefaultInteractor(
                        repository: AdminGetHomeOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminGetHomeDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine,
                        permissions: context.currentUserPermissions
                    )
                )
            }
        )
    }

}
