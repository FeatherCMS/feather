import FeatherAdmin
import FeatherValidation

struct AdminRemoveContactFormSubmissions {
    let controller: any AdminRemoveContactFormSubmissionsController

    init(apiBuilder: ContactAPIBuilder,
        renderingEngine: any RenderingEngine) {
        controller = AdminRemoveContactFormSubmissionsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor:
                        AdminRemoveContactFormSubmissionsDefaultInteractor(
                            repository: .init(
                                api: apiBuilder.makeContactAdmin(context)
                            )
                        ),
                    presenter:
                        AdminRemoveContactFormSubmissionsDefaultPresenter(
                            request: request,
                            context: context,
                            renderingEngine: renderingEngine
                        )
                )
            }
        )
    }
}
