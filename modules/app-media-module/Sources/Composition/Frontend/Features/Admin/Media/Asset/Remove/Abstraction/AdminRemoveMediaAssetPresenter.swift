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

protocol AdminRemoveMediaAssetPresenter: Sendable {

    func renderRemovePage(model: AdminRemoveMediaAssetModel)
        async throws -> HTMLResponse

}
