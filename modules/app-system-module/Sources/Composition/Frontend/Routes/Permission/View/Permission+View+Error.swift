import FeatherAdmin
import SystemModule

extension WebAdmin.System.Permission.View {
    enum Error: Swift.Error, Sendable {
        case notFound
        case unauthorized
        case forbidden
        case unavailable
    }
}
