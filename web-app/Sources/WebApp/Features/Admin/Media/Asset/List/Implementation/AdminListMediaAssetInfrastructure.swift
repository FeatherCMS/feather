import AdminOpenAPI
import Foundation

struct AdminListMediaAssetInfrastructure: Sendable {
    let repository: AdminMediaAssetOpenAPIRepository

    init(api: AdminAPI) {
        self.repository = .init(api: api)
    }
}
