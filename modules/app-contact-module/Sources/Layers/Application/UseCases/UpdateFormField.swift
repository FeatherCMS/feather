import ContactContracts
import ContactDomain
import FeatherApplication
import FeatherContracts

public struct UpdateFormField: UseCase {
    struct Error: UseCaseError { let message: String }
    struct Action: PermissionAction {
        let key = ContactPermissions.Fields.update
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteForm>
    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteForm>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }
    public struct Input: DTO {
        public let id: String
        public let formId: String?
        public let key: String?
        public let type: FormField.ItemType?
        public let label: String?
        public let allowedValues: [FormField.Option]?
        public let isRequired: Bool?
        public let position: Int?
        public init(
            id: String,
            formId: String?,
            key: String? = nil,
            type: FormField.ItemType? = nil,
            label: String? = nil,
            allowedValues: [FormField.Option]? = nil,
            isRequired: Bool? = nil,
            position: Int? = nil
        ) {
            self.id = id
            self.formId = formId
            self.key = key
            self.type = type
            self.label = label
            self.allowedValues = allowedValues
            self.isRequired = isRequired
            self.position = position
        }
    }
    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> FormFieldDetail {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            guard
                var value = try await scope.field.findBy(
                    id: input.id,
                    formId: input.formId
                )
            else {
                throw Error(message: "Contact form field not found")
            }
            try value.update(
                key: input.key,
                type: input.type,
                label: input.label,
                allowedValues: input.allowedValues,
                isRequired: input.isRequired,
                position: input.position
            )
            return try await scope.field.update(value).asDetail
        }
    }
}
