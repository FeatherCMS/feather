import FeatherWebAdmin
import SystemModule

extension Permission.Edit {
    enum Repository {}
}

extension Permission.Edit.Repository {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> Permission.View.Result

        func update(
            id: String,
            input: Permission.Edit.Form.Input
        ) async throws
    }
}
