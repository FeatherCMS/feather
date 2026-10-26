import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension FormField.Edit {
    enum Interactor {}
}

extension FormField.Edit.Interactor {
    protocol Interface: Sendable {
        func get(id: String) async throws -> FormField.Model
        func update(id: String, form: FormField.Add.Form.Input)
            async throws
    }
}
