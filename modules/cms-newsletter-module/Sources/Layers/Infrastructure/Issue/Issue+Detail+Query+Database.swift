import FeatherDBAL
public import FeatherInfrastructure
public import NewsletterApplication
import NewsletterDomain
public import NewsletterModule

extension Issue.Detail.Query {
    public struct Database: Interface {
        private let campaignAccessLayer: DatabaseAccessLayer<Campaign.Table>
        private let issueAccessLayer: DatabaseAccessLayer<Issue.Table>

        public init(context: any DatabaseContext) {
            self.campaignAccessLayer = .init(context: context)
            self.issueAccessLayer = .init(context: context)
        }

        public func find(
            campaignKey: String,
            id: String
        ) async throws -> Issue.Detail.Output {
            guard
                let campaign = try await campaignAccessLayer.selectFirst(
                    by: \.key,
                    equals: campaignKey
                ),
                let issue = try await issueAccessLayer.selectFirst(
                    by: \.id,
                    equals: id
                ),
                issue.newsletterId == campaign.id
            else {
                throw QueryError.notFound
            }

            guard let status = Issue.Model.Status(rawValue: issue.status) else {
                throw QueryError(
                    reason: .database,
                    logMessage:
                        "Invalid newsletter issue status: \(issue.status)",
                    userFriendlyMessage: "Unable to read the newsletter issue."
                )
            }

            return .init(
                id: issue.id,
                newsletterId: issue.newsletterId,
                subject: issue.subject,
                previewText: issue.previewText,
                content: issue.content,
                status: status,
                scheduledDate: issue.scheduledDate,
                sentDate: issue.sentDate,
                createdAt: issue.createdAt,
                updatedAt: issue.updatedAt
            )
        }
    }
}
