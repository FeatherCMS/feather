import ContactApplication
import ContactModule

extension FormField.List {
    enum Interactor {}
}

extension FormField.List.Interactor {
    protocol Interface: Sendable {
        func search(
            page: Int,
            search: String?,
            formKey: String?
        ) async throws -> FormField.List.Model
    }
}
