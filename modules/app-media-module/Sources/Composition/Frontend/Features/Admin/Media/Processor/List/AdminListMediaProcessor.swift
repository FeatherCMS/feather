import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListMediaProcessor {
    let controller: any AdminListMediaProcessorController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminListMediaProcessorDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListMediaProcessorDefaultInteractor(
                        repository: AdminMediaProcessorOpenAPIRepository(
                            api: context.mediaAdminAPI()
                        )
                    ),
                    presenter: AdminListMediaProcessorDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
