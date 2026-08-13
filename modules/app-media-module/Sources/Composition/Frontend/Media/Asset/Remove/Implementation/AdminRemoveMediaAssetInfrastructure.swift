import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveMediaAssetInfrastructure: Sendable {
    let repository: AdminMediaAssetOpenAPIRepository

    init(api: MediaAdminAPIClient) {
        self.repository = .init(api: api)
    }
}
