import AdminOpenAPI
import Foundation

struct AdminGetMediaAssetInfrastructure: Sendable {
    let repository: AdminMediaAssetOpenAPIRepository

    init(api: AdminAPI) {
        self.repository = .init(api: api)
    }
}
