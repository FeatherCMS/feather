import AccountDomain
public import AccountModule
public import FeatherApplication
public import FeatherModuleKit

extension Profile.Detail {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let query: any QueryExecutor<Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Scope>
        ) {
            self.authorizer = authorizer
            self.query = query
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Output {
            let userId = input.userId ?? subject.id
            let action = Action(userID: userId)
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }
            return try await query.run { scope in
                let profile = try await scope.query.get(userId: userId)
                return .init(
                    userId: profile.userId,
                    firstName: profile.firstName,
                    lastName: profile.lastName,
                    profileImageAssetId: profile.profileImageAssetId,
                    createdAt: profile.createdAt,
                    updatedAt: profile.updatedAt
                )
            }
        }
    }
}
