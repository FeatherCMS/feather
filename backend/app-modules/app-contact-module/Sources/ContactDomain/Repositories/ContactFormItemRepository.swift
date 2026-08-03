import Domain

public protocol ContactFormItemRepository: Repository {

    func findBy(
        id: String,
        formId: String?
    ) async throws -> ContactFormItem?

    func listBy(
        formId: String?
    ) async throws -> [ContactFormItem]

    func assign(
        formId: String,
        itemId: String,
        position: Int
    ) async throws

    func unassign(
        formId: String,
        itemId: String
    ) async throws

    func insert(
        _ model: ContactFormItem.New
    ) async throws -> ContactFormItem

    func update(
        _ model: ContactFormItem
    ) async throws -> ContactFormItem

    func delete(
        id: String,
        formId: String?
    ) async throws -> Bool
}
