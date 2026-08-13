import ContactDomain
import FeatherApplication
import FeatherContracts

public struct GetPublicForm {
    let transaction: any TransactionExecutor<WriteForm>

    public init(
        transaction: any TransactionExecutor<WriteForm>
    ) {
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String

        public init(
            id: String
        ) {
            self.id = id
        }
    }

    public func execute(
        _ input: Input
    ) async throws -> FormDetail {
        try await transaction.run { scope in
            guard let value = try await scope.form.findBy(id: input.id) else {
                throw Error.notFound
            }
            let fields = try await scope.field.listBy(formId: input.id)
                .map(\.asDetail)
            return value.asDetail(fields: fields)
        }
    }

    public enum Error: UseCaseError {
        case notFound
    }
}
