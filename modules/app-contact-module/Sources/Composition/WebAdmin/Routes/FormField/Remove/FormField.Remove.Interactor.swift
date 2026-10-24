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

extension FormField.Remove {
    enum Interactor {}
}

extension FormField.Remove.Interactor {
    protocol Interface: Sendable {
        func get(id: String) async throws -> FormField.Model
        func remove(id: String) async throws
        func remove(ids: [String]) async throws
    }
}
