import Domain

public protocol ContactFormRepository: Repository {

    func list() async throws -> [ContactForm]

    func findBy(
        id: String
    ) async throws -> ContactForm?

    func insert(
        _ model: ContactForm.New
    ) async throws -> ContactForm

    func update(
        _ model: ContactForm
    ) async throws -> ContactForm

    func delete(
        id: String
    ) async throws -> Bool
}
