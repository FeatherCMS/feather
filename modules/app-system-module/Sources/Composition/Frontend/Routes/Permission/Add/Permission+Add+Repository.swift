import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Permission.Add {
    enum Repository {}
}

extension WebAdmin.System.Permission.Add.Repository {
    protocol Interface: Sendable {

        func create(
            entity: WebAdmin.System.Permission.Add.Model
        ) async throws
    }
}
