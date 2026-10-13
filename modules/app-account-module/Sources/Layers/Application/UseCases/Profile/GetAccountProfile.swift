import AccountContracts
public import FeatherApplication
public import FeatherContracts

public struct GetAccountProfile: UseCase {
    struct Action: PermissionAction {
        let key = AccountPermissions.Profile.read
        let userID: String

        func authorize(
            subject: Subject,
            permissions: Set<PermissionKey>
        ) async throws -> Bool {
            userID == subject.id || permissions.contains(key)
        }
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadAccountProfile>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadAccountProfile>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let userId: String?

        public init(userId: String? = nil) {
            self.userId = userId
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> AccountProfileDetail {
        let userId = input.userId ?? subject.id
        let action = Action(userID: userId)
        guard try await authorizer.can(subject: subject, perform: action)
        else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await query.run { scope in
            try await scope.profile.get(userId: userId).asDetail
        }
    }
}
