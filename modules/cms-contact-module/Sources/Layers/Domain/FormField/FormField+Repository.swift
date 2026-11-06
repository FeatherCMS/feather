public import ContactModule
public import FeatherDomain

extension FormField {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func findBy(
                id: String,
                formId: String?
            ) async throws -> Model?

            func listBy(
                formId: String?
            ) async throws -> [Model]

            func listUnassigned() async throws -> [Model]

            func assign(
                formId: String,
                fieldId: String,
                position: Int
            ) async throws

            func unassign(
                formId: String,
                fieldId: String
            ) async throws

            func insert(
                _ model: Model.New
            ) async throws -> Model

            func update(
                _ model: Model
            ) async throws -> Model

            func delete(
                ids: [String],
                formId: String?
            ) async throws -> [String]
        }
    }
}
