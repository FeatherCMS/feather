import NewsApplication
import NewsModule

extension Category.Add.Interactor {
    struct Default: Interface {
        let repository: any Category.Add.Repository.Interface

        func create(
            input: Category.Form.Input
        ) async throws -> String {
            try await repository.create(input: input)
        }
    }
}
