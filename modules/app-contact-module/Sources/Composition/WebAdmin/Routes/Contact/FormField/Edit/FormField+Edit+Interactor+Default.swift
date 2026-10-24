import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension FormField.Edit.Interactor {
    struct Default: Interface {
        let repository: any FormField.Edit.Repository.Interface
        func get(id: String) async throws -> FormField.Model {
            do {
                return try await repository.get(id: id)
            }
            catch let error as OpenAPIRepositoryError {
                throw map(error)
            }
        }
        func update(id: String, form: FormField.Add.Form.Input) async throws {
            do {
                try await repository.update(id: id, form: form)
            }
            catch let error as OpenAPIRepositoryError {
                throw map(error)
            }
        }

        private func map(
            _ error: OpenAPIRepositoryError
        ) -> FormField.Edit.Error {
            switch error {
            case .notFound:
                .notFound
            case .unauthorized:
                .unauthorized
            case .forbidden:
                .forbidden
            case .conflict:
                .conflict
            case .failure, .transport:
                .unavailable
            }
        }
    }
}
