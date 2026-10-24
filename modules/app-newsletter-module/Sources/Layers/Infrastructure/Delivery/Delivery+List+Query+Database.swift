import FeatherDBAL
public import FeatherInfrastructure
public import NewsletterApplication
import NewsletterDomain
public import NewsletterModule

extension Delivery.List.Query {
    public struct Database: Interface {
        private let campaignAccessLayer: DatabaseAccessLayer<Campaign.Table>
        private let issueAccessLayer: DatabaseAccessLayer<Issue.Table>
        private let deliveryAccessLayer: DatabaseAccessLayer<Delivery.Table>

        public init(context: any DatabaseContext) {
            self.campaignAccessLayer = .init(context: context)
            self.issueAccessLayer = .init(context: context)
            self.deliveryAccessLayer = .init(context: context)
        }

        public func list(input: Delivery.List.Input) async throws
            -> Delivery.List.Output
        {
            guard
                let campaign = try await campaignAccessLayer.selectFirst(
                    by: \.key,
                    equals: input.campaignKey
                ),
                let issue = try await issueAccessLayer.selectFirst(
                    by: \.id,
                    equals: input.issueId
                ),
                issue.newsletterId == campaign.id
            else {
                throw QueryError.notFound
            }

            let rows = try await deliveryAccessLayer.select(
                as: Delivery.Table.List.self
            ) {
                $0.where(\.issueId, equals: issue.id)
                    .order(by: \.createdAt)
                    .order(by: \.subscriberEmail)
            }
            let items = try rows.map { row in
                guard let status = Delivery.Model.Status(rawValue: row.status)
                else {
                    throw QueryError(
                        reason: .database,
                        logMessage:
                            "Invalid newsletter delivery status: \(row.status)",
                        userFriendlyMessage:
                            "Unable to read newsletter deliveries."
                    )
                }
                let model = Delivery.Model(
                    issueId: row.issueId,
                    newsletterId: row.newsletterId,
                    subscriberEmail: row.subscriberEmail,
                    status: status,
                    sentDate: row.sentDate,
                    failureReason: row.failureReason,
                    createdAt: row.createdAt,
                    updatedAt: row.updatedAt
                )
                return Delivery.List.Item(model: model)
            }
            return .init(items: items)
        }
    }
}
