import AccountContracts
import AccountDomain
import FeatherApplication
import FeatherContracts

public struct EditAccountProfile: UseCase {
    struct Action: PermissionAction {
        let key: PermissionKey
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteAccountProfile>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteAccountProfile>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let firstName: String?
        public let lastName: String?
        public let imageURL: String?
        public let userId: String?

        public init(
            firstName: String?,
            lastName: String?,
            imageURL: String?,
            userId: String? = nil
        ) {
            self.firstName = firstName
            self.lastName = lastName
            self.imageURL = imageURL
            self.userId = userId
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> AccountProfileDetail {
        let userId = input.userId ?? subject.id
        let action = Action(
            key: userId == subject.id
                ? AccountPermissions.Profile.update
                : AccountPermissions.Profile.manage
        )
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        let model = try await transaction.run { scope in
            var model = try await scope.profile.getOrCreate(userId: userId)
            try model.update(
                firstName: input.firstName,
                lastName: input.lastName,
                imageURL: input.imageURL
            )
            return try await scope.profile.update(model)
        }
        return model.asDetail
    }
}
