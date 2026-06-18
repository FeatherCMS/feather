import Hummingbird

struct AdminGetBlogHome {
    let controller: any AdminGetBlogHomeController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetBlogHomeDefaultController(
            buildRuntime: { request, _ in
                (
                    interactor: AdminGetBlogHomeDefaultInteractor(),
                    presenter: AdminGetBlogHomeDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
