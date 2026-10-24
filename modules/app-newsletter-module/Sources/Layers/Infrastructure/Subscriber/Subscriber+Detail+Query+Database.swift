import FeatherDBAL
public import FeatherInfrastructure
public import NewsletterApplication
import NewsletterDomain
public import NewsletterModule

extension Subscriber.Detail.Query {
    public struct Database: Interface {
        private let campaignAccessLayer: DatabaseAccessLayer<Campaign.Table>
        private let subscriberAccessLayer: DatabaseAccessLayer<Subscriber.Table>

        public init(context: any DatabaseContext) {
            self.campaignAccessLayer = .init(context: context)
            self.subscriberAccessLayer = .init(context: context)
        }

        public func find(
            campaignKey: String,
            email: String
        ) async throws -> Subscriber.Detail.Output {
            guard
                let campaign = try await campaignAccessLayer.selectFirst(
                    by: \.key,
                    equals: campaignKey
                )
            else {
                throw QueryError.notFound
            }

            let subscribers = try await subscriberAccessLayer.select(
                as: Subscriber.Table.Detail.self
            ) {
                $0.where(\.newsletterId, equals: campaign.id)
                    .where(\.email, equals: email)
                    .limit(1)
            }
            guard let subscriber = subscribers.first else {
                throw QueryError.notFound
            }

            guard
                let status = Subscriber.Model.Status(
                    rawValue: subscriber.status
                )
            else {
                throw QueryError(
                    reason: .database,
                    logMessage:
                        "Invalid newsletter subscriber status: \(subscriber.status)",
                    userFriendlyMessage:
                        "Unable to read the newsletter subscriber."
                )
            }

            return .init(
                newsletterId: subscriber.newsletterId,
                email: subscriber.email,
                status: status,
                subscriptionDate: subscriber.subscriptionDate,
                unsubscriptionDate: subscriber.unsubscriptionDate,
                firstName: subscriber.firstName,
                lastName: subscriber.lastName,
                confirmedAt: subscriber.confirmedAt,
                source: subscriber.source,
                lastSentAt: subscriber.lastSentAt,
                createdAt: subscriber.createdAt,
                updatedAt: subscriber.updatedAt
            )
        }
    }
}
