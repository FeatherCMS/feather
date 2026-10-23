import ContactApplication
import ContactModule

extension FormField.Add {
    enum Interactor {}
}

extension FormField.Add.Interactor {
    protocol Interface: Sendable {
        func getAddContactField() async throws -> FormField.Add.Model

        func postAddContactField(
            payload: ContactFieldFormInput,
            formKey: String?
        ) async throws -> FormField.Add.Model
    }
}
