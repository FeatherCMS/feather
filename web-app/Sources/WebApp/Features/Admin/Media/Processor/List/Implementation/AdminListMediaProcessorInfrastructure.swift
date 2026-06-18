import AdminOpenAPI
import Foundation

struct AdminListMediaProcessorInfrastructure: Sendable {
    let repository: AdminMediaProcessorOpenAPIRepository

    init(api: AdminAPI) {
        self.repository = .init(api: api)
    }
}
