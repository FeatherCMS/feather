import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminEditMediaFolder {
    let controller: any AdminEditMediaFolderController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditMediaFolderDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditMediaFolderDefaultInteractor(
                        repository: AdminEditMediaFolderOpenAPIRepository(
                            api: context.mediaManagementAPI()
                        )
                    ),
                    presenter: AdminEditMediaFolderDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
