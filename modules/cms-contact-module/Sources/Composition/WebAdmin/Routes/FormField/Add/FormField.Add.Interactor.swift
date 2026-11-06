import ContactApplication
import ContactModule

extension FormField.Add {
    enum Interactor {}
}

extension FormField.Add.Interactor {
    protocol Interface: Sendable {
        func getAddContactField() async throws -> FormField.Add.Model

        func postAddContactField(
            payload: FormField.Add.Form.Input,
            formKey: String?
        ) async throws -> FormField.Add.Model
    }
}
