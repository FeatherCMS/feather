import FeatherAdmin
import Hummingbird
import SystemModule

extension Permission.Add {
    enum Repository {}
}

extension Permission.Add.Repository {
    protocol Interface: Sendable {

        func create(
            entity: Permission.Add.Model
        ) async throws
    }
}
