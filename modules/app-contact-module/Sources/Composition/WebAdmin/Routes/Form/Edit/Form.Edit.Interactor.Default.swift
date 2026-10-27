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

extension ContactModule.Form.Edit.Interactor {
    struct Default: Interface {
        let repository: any ContactModule.Form.Edit.Repository.Interface

        func get(key: String) async throws -> ContactModule.Form.Details.Item {
            do {
                return try await repository.get(key: key)
            }
            catch let error as OpenAPIRepositoryError {
                throw map(error)
            }
        }

        func update(
            key: String,
            newKey: String,
            name: String,
            successMessage: String,
            failureMessage: String,
            submitLabel: String,
            redirectUrl: String?,
            fieldIDs: [String],
            mails: [ContactModule.Form.Email]
        ) async throws {
            do {
                _ = try await repository.update(
                    key: key,
                    newKey: newKey,
                    name: name,
                    successMessage: successMessage,
                    failureMessage: failureMessage,
                    submitLabel: submitLabel,
                    redirectUrl: redirectUrl,
                    fieldIDs: fieldIDs,
                    mails: mails
                )
            }
            catch let error as OpenAPIRepositoryError {
                throw map(error)
            }
        }

        private func map(
            _ error: OpenAPIRepositoryError
        ) -> ContactModule.Form.Edit.Repository.Error {
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
