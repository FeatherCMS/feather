import FeatherWebAdmin
import UserModule

extension Role.Add {
    enum Repository {}
}



extension Role.Add.Repository {
    protocol Interface: Sendable {

        func create(
            payload: Role.Add.FormPayload
        ) async throws
    }
}
