import FeatherDBAL
public import FeatherInfrastructure
public import NewsletterApplication
import NewsletterDomain
public import NewsletterModule

extension Issue.List.Query {
    public struct Database: Interface {
        private let campaignAccessLayer: DatabaseAccessLayer<Campaign.Table>
        private let issueAccessLayer: DatabaseAccessLayer<Issue.Table>

        public init(context: any DatabaseContext) {
            self.campaignAccessLayer = .init(context: context)
            self.issueAccessLayer = .init(context: context)
        }

        public func list(campaignKey: String) async throws -> Issue.List.Output
        {
            guard
                let campaign = try await campaignAccessLayer.selectFirst(
                    by: \.key,
                    equals: campaignKey
                )
            else {
                throw QueryError.notFound
            }

            let rows = try await issueAccessLayer.select(
                as: Issue.Table.List.self
            ) {
                $0.where(\.newsletterId, equals: campaign.id)
                    .order(by: \.createdAt, .descending)
                    .order(by: \.id, .descending)
            }
            let items = try rows.map { row in
                guard let status = Issue.Model.Status(rawValue: row.status)
                else {
                    throw QueryError(
                        reason: .database,
                        logMessage:
                            "Invalid newsletter issue status: \(row.status)",
                        userFriendlyMessage:
                            "Unable to read newsletter issues."
                    )
                }
                let model = Issue.Model(
                    id: row.id,
                    newsletterId: row.newsletterId,
                    subject: row.subject,
                    previewText: row.previewText,
                    content: row.content,
                    status: status,
                    scheduledDate: row.scheduledDate,
                    sentDate: row.sentDate,
                    createdAt: row.createdAt,
                    updatedAt: row.updatedAt
                )
                return Issue.List.Item(model: model)
            }

            return .init(items: items)
        }
    }
}
