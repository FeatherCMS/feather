public import FeatherApplication
public import FeatherModuleKit
import NewsletterDomain
public import NewsletterModule

extension Subscriber.List {
    public struct UseCase: FeatherApplication.UseCase {
    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<Subscriber.List.Scope>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<Subscriber.List.Scope>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> Output {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            let campaignID: String
            switch input.campaignIdentifier {
            case .id(let id):
                campaignID = id
            case .key(let key):
                guard let campaign = try await scope.newsletter.findBy(key: key)
                else { throw Error.campaignNotFound }
                campaignID = campaign.id
            }
            let items = try await scope.subscriber.list(newsletterId: campaignID)
                .map(Output.Item.init(model:))
            return .init(items: items)
        }
    }
}
