public import ContactDomain
public import ContactModule
public import FeatherApplication
public import FeatherModuleKit

public struct CreateFormField: UseCase {
    struct Action: PermissionAction {
        let key = FormField.Permissions.create
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
        public let type: FormField.Model.ItemType
        public let label: String
        public let allowedValues: [FormField.Model.Option]
        public let isRequired: Bool
        public let position: Int

        public init(
            formId: String?,
            key: String,
            type: FormField.Model.ItemType,
            label: String,
            allowedValues: [FormField.Model.Option] = [],
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
    ) async throws -> FormField.Add.Output {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            let model = try FormField.Model.create(
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
            return .init(model: field)
        }
    }
}
