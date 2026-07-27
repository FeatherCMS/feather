import Hummingbird

struct AdminGetSystemJob {
    let controller: any AdminGetSystemJobController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminGetSystemJobDefaultController(
            buildRuntime: { request, context in
                (
                    repository: AdminGetSystemJobOpenAPIRepository(
                        api: context.managementAPI()
                    ),
                    presenter: AdminGetSystemJobDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
