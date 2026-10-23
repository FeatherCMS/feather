import ContactWebShared
import FeatherWebAdmin

struct AdminListContactSubmissions {
    let controller: any AdminListContactSubmissionsController

    init(
        apiBuilder: ContactAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminListContactSubmissionsDefaultController(
            buildRuntime: { request, context in
                WebAdminRuntime(
                    interactor: AdminListContactSubmissionsDefaultInteractor(
                        repository: .init(
                            api: apiBuilder.makeContactAdmin(context)
                        )
                    ),
                    presenter: AdminListContactSubmissionsDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
