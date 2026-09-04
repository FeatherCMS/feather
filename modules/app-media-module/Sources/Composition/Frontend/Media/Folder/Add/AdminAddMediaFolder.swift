import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddMediaFolder {
    let controller: any AdminAddMediaFolderController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminAddMediaFolderDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddMediaFolderDefaultInteractor(
                        repository: AdminAddMediaFolderOpenAPIRepository(
                            api: context.mediaAdminAPI()
                        )
                    ),
                    presenter: AdminAddMediaFolderDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
