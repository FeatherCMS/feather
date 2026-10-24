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

extension FormField.Remove.Interactor {
    struct Default: Interface {
        let repository: any FormField.Remove.Repository.Interface

        func get(id: String) async throws -> FormField.Model {
            try await repository.get(id: id)
        }

        func remove(id: String) async throws {
            try await repository.remove(id: id)
        }

        func remove(ids: [String]) async throws {
            try await repository.remove(ids: ids)
        }
    }
}
