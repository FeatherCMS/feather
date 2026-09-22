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
        public let key: String

        public init(
            key: String
        ) {
            self.key = key
        }
    }

    public func execute(
        _ input: Input
    ) async throws -> FormDetail {
        try await transaction.run { scope in
            guard let value = try await scope.form.findBy(key: input.key) else {
                throw Error.formNotFound
            }
            let fields = try await scope.field.listBy(formId: value.id)
                .map(\.asDetail)
            return value.asDetail(fields: fields)
        }
    }

    public enum Error: UseCaseError {
        case formNotFound
    }
}
