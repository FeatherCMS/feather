import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListMediaAssetInfrastructure: Sendable {
    let repository: AdminListMediaAssetOpenAPIRepository

    init(api: MediaAdminAPIClient) {
        self.repository = .init(api: api)
    }
}
