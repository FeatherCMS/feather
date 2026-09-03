import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import WebContracts

struct AdminListWebMetadata {
    let controller: any AdminListWebMetadataController

    init(
        renderingEngine: any RenderingEngine,
        referenceTypeOptions: [WebMetadataReferenceTypeOption] = []
    ) {
        self.controller = AdminListWebMetadataDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListWebMetadataDefaultInteractor(
                        repository: AdminListWebMetadataOpenAPIRepository(
                            api: context.webAdminAPI()
                        )
                    ),
                    presenter: AdminListWebMetadataDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine,
                        referenceTypeOptions: referenceTypeOptions
                    )
                )
            }
        )
    }
}
