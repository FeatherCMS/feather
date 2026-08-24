import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import WebContracts

struct AdminEditWebMetadata {
    let controller: any AdminEditWebMetadataController

    init(
        renderingEngine: any RenderingEngine,
        templateOptions: [WebPageTemplateOption] = []
    ) {
        self.controller = AdminEditWebMetadataDefaultController(
            templateOptions: templateOptions,
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebMetadataDefaultInteractor(
                        repository: AdminEditWebMetadataOpenAPIRepository(
                            api: context.webManagementAPI()
                        )
                    ),
                    presenter: AdminEditWebMetadataDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
