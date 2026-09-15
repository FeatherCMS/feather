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

protocol AdminRemoveMediaProcessorPresenter: Sendable {

    func renderRemovePage(model: AdminRemoveMediaProcessorModel)
        async throws -> HTMLResponse
}
