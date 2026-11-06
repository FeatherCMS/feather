import FeatherWebAdmin
import SystemModule

extension Permission.View {
    enum Error: Swift.Error, Sendable {
        case notFound
        case unauthorized
        case forbidden
        case unavailable
    }
}
