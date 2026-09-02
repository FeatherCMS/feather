import FeatherDomain

public protocol FormFieldRepository: Repository {

    func findBy(
        id: String,
        formId: String?
    ) async throws -> FormField?

    func listBy(
        formId: String?
    ) async throws -> [FormField]

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
        _ model: FormField.New
    ) async throws -> FormField

    func update(
        _ model: FormField
    ) async throws -> FormField

    func delete(
        ids: [String],
        formId: String?
    ) async throws -> [String]
}
