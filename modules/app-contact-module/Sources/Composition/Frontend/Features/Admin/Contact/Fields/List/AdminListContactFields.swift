import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFields {
    let controller: any AdminListContactFieldsController

    init(
        apiBuilder: ContactAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminListContactFieldsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListContactFieldsDefaultInteractor(
                        repository: .init(
                            api: apiBuilder.makeContactAdmin(context)
                        )
                    ),
                    presenter: AdminListContactFieldsDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }

}
