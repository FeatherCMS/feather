import FeatherDBAL
public import FeatherInfrastructure
public import NewsletterApplication
import NewsletterDomain
public import NewsletterModule

extension Subscriber.List.Query {
    public struct Database: Interface {
        private let campaignAccessLayer: DatabaseAccessLayer<Campaign.Table>
        private let subscriberAccessLayer: DatabaseAccessLayer<Subscriber.Table>

        public init(context: any DatabaseContext) {
            self.campaignAccessLayer = .init(context: context)
            self.subscriberAccessLayer = .init(context: context)
        }

        public func list(newsletterId: String) async throws
            -> Subscriber.List.Output
        {
            let rows = try await subscriberAccessLayer.select(
                as: Subscriber.Table.List.self
            ) {
                $0.where(\.newsletterId, equals: newsletterId)
                    .order(by: \.email)
            }
            let items = try rows.map { row in
                guard let status = Subscriber.Model.Status(rawValue: row.status)
                else {
                    throw QueryError(
                        reason: .database,
                        logMessage:
                            "Invalid newsletter subscriber status: \(row.status)",
                        userFriendlyMessage:
                            "Unable to read newsletter subscribers."
                    )
                }

                let model = Subscriber.Model(
                    newsletterId: row.newsletterId,
                    email: row.email,
                    status: status,
                    subscriptionDate: row.subscriptionDate,
                    unsubscriptionDate: row.unsubscriptionDate,
                    firstName: row.firstName,
                    lastName: row.lastName,
                    confirmedAt: row.confirmedAt,
                    unsubscribeToken: row.unsubscribeToken,
                    source: row.source,
                    lastSentAt: row.lastSentAt,
                    createdAt: row.createdAt,
                    updatedAt: row.updatedAt
                )
                return Subscriber.List.Item(model: model)
            }
            return .init(items: items)
        }

        public func list(campaignKey: String) async throws
            -> Subscriber.List.Output
        {
            guard
                let campaign = try await campaignAccessLayer.selectFirst(
                    by: \.key,
                    equals: campaignKey
                )
            else {
                throw QueryError.notFound
            }

            return try await list(newsletterId: campaign.id)
        }
    }
}
