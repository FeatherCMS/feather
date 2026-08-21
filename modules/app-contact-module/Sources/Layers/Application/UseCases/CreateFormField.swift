import ContactContracts
import ContactDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain

public struct CreateFormField: UseCase {
    struct Action: PermissionAction {
        let key = ContactPermissions.Fields.create
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
        public let formId: String?
        public let key: String
        public let type: FormField.ItemType
        public let label: String
        public let allowedValues: [FormField.Option]
        public let isRequired: Bool
        public let position: Int

        public init(
            formId: String?,
            key: String,
            type: FormField.ItemType,
            label: String,
            allowedValues: [FormField.Option] = [],
            isRequired: Bool = false,
            position: Int = 0
        ) {
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
            let model = try FormField.create(
                formId: input.formId ?? "",
                key: input.key,
                type: input.type,
                label: input.label,
                allowedValues: input.allowedValues,
                isRequired: input.isRequired,
                position: input.position
            )
            let field = try await scope.field.insert(model)
            if let formId = input.formId {
                try await scope.field.assign(
                    formId: formId,
                    fieldId: field.id,
                    position: input.position
                )
            }
            return field.asDetail
        }
    }
}
