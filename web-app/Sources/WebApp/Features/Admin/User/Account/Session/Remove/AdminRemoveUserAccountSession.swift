import Hummingbird

struct AdminRemoveUserAccountSession {
    let controller: any AdminRemoveUserAccountSessionController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminRemoveUserAccountSessionDefaultController(
            buildRuntime: { request, context in
                let api = context.managementAPI()
                return (
                    interactor: AdminRemoveUserAccountSessionDefaultInteractor(
                        repository:
                            AdminRemoveUserAccountSessionOpenAPIRepository(
                                api: api
                            )
                    ),
                    presenter: AdminRemoveUserAccountSessionDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
