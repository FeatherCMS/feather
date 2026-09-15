import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminViewWebMetadata {
    let controller: any AdminViewWebMetadataController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminViewWebMetadataDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewWebMetadataDefaultInteractor(
                        repository: AdminViewWebMetadataOpenAPIRepository(
                            api: context.webAdminAPI()
                        )
                    ),
                    presenter: AdminViewWebMetadataDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }
}
