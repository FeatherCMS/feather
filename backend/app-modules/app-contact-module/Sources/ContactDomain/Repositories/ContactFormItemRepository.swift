import Domain

public protocol ContactFormItemRepository: Repository {

    func findBy(
        id: String
    ) async throws -> ContactFormItem?

    func listBy(
        formId: String
    ) async throws -> [ContactFormItem]

    func insert(
        _ model: ContactFormItem.New
    ) async throws -> ContactFormItem

    func update(
        _ model: ContactFormItem
    ) async throws -> ContactFormItem

    func delete(
        id: String
    ) async throws -> Bool
}
