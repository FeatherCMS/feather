import AdminOpenAPI
import Foundation

struct AdminRemoveMediaAssetInfrastructure: Sendable {
    let repository: AdminMediaAssetOpenAPIRepository

    init(api: AdminAPI) {
        self.repository = .init(api: api)
    }
}
