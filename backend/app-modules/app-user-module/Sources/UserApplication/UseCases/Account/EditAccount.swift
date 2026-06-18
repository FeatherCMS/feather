import Application
import Domain
import UserDomain

public struct EditAccount: UseCase {
    struct Action: PermissionAction {
        let key: PermissionKey

        init(isSelfService: Bool) {
            self.key =
                isSelfService
                ? .init("auth:profile:update") : UserPermissions.Accounts.update
        }
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteAccount>
    let passwordHasher: any PasswordHasher

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteAccount>,
        passwordHasher: any PasswordHasher
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.passwordHasher = passwordHasher
    }

    public struct Input: DTO {
        public let id: String
        public let email: String?
        public let password: String?
        public let roleIds: [String]?
        public let status: Account.Status?

        public init(
            id: String,
            email: String?,
            password: String?,
            roleIds: [String]?,
            status: Account.Status?
        ) {
            self.id = id
            self.email = email
            self.password = password
            self.roleIds = roleIds
            self.status = status
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> AccountDetail {
        let action = Action(isSelfService: input.id == subject.id)

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let password = input.password
        let passwordHash: String?

        if let password = input.password {
            passwordHash = try await hashPassword(
                using: passwordHasher,
                original: password
            )
        }
        else {
            passwordHash = nil
        }

        let model = try await transaction.run { context in
            guard var model = try await context.account.findBy(id: input.id)
            else {
                throw Error(message: "Account not found")
            }

            try model.update(
                email: input.email,
                password: password,
                passwordHash: passwordHash,
                status: input.status
            )

            let updated = try await context.account.update(model)

            if let roleIds = input.roleIds {
                for roleId in roleIds {
                    guard try await context.role.findBy(id: roleId) != nil
                    else {
                        throw Error(message: "Role not found: \(roleId)")
                    }
                }
                try await context.account.replaceRoleIds(
                    accountId: model.id,
                    roleIds: roleIds
                )
            }

            return updated
        }
        return model.asDetail
    }
}
