import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminGetWebMetadata {
    let controller: any AdminGetWebMetadataController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetWebMetadataDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetWebMetadataDefaultInteractor(
                        repository: AdminGetWebMetadataOpenAPIRepository(
                            api: context.webAdminAPI()
                        )
                    ),
                    presenter: AdminGetWebMetadataDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
