public import ContactModule
public import FeatherDomain

extension Submission {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func listBy(
                formId: String
            ) async throws -> [Model]

            func findBy(
                id: String
            ) async throws -> Model?

            func insert(
                _ model: Model.New
            ) async throws -> Model

            func update(
                _ model: Model
            ) async throws -> Model

            func delete(
                ids: [String]
            ) async throws -> [String]
        }
    }
}
