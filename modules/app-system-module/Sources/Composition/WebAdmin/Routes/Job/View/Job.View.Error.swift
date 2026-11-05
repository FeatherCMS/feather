import FeatherWebAdmin
import SystemModule

extension Job.View {
    enum Error: Swift.Error, Sendable {
        case notFound
        case unauthorized
        case forbidden
        case unavailable
    }
}
