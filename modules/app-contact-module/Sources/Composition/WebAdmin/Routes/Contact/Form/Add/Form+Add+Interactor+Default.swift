import ContactApplication
import ContactModule
import FeatherWebShared

extension Form.Add.Interactor {
    struct Default: Interface {
        let repository: any Form.Add.Repository.Interface

        func availableFields() async throws -> [ContactForm.Field.Option] {
            try await repository.availableFields()
        }

        func create(entity: Form.Add.Model) async throws
            -> ContactForm.Details.Item
        {
            do {
                return try await repository.create(entity: entity)
            }
            catch let error as OpenAPIRepositoryError {
                switch error {
                case .unauthorized:
                    throw Form.Add.Error.unauthorized
                case .forbidden:
                    throw Form.Add.Error.forbidden
                case .conflict:
                    throw Form.Add.Error.conflict
                case .notFound, .failure, .transport:
                    throw Form.Add.Error.unavailable
                }
            }
        }
    }
}
