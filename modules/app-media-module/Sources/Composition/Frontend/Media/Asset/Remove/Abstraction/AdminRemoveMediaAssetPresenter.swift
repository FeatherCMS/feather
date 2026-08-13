import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveMediaAssetPresenter: Sendable {

    func renderPage(
        model: AdminRemoveMediaAssetModel,
        permissions: Set<String>
    ) -> HTMLResponse

}
