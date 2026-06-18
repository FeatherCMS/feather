import Hummingbird

struct AdminEditAuthAccessControl {

    let controller: any AdminEditAuthAccessControlController

    init(
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditAuthAccessControlDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditAuthAccessControlDefaultInteractor(
                        repository: AdminEditAuthAccessControlOpenAPIRepository(
                            api: context.managementAPI()
                        )
                    ),
                    presenter: AdminEditAuthAccessControlDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
