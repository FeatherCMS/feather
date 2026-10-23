import FeatherDBAL
import NewsletterModule
import Testing

@testable import NewsletterInfrastructure

@Suite
struct NewsletterInfrastructureTestSuite {

    @Test
    func campaignSchemaDefinesIdentityTimestampsAndIndex() {
        let schema = Campaign.Table.tableCreationSchema

        #expect(schema.name == "newsletter_campaign")
        #expect(
            schema.columns.map(\.name) == [
                "id", "key", "name", "from_email", "created_at", "updated_at",
            ]
        )
        #expect(
            schema.constraints.contains {
                guard case .primaryKey(let columns) = $0 else { return false }
                return columns.map(\.name) == ["id"]
            }
        )
        #expect(schema.indexes.map(\.name) == ["newsletter_campaign_key_idx"])
    }

    @Test
    func subscriberSchemaDefinesCompositeKeyAndCampaignRelation() {
        let schema = Subscriber.Table.tableCreationSchema

        #expect(schema.name == "newsletter_subscriber")
        #expect(
            schema.constraints.contains {
                guard case .primaryKey(let columns) = $0 else { return false }
                return columns.map(\.name) == ["newsletter_id", "email"]
            }
        )
        #expect(
            schema.constraints.contains {
                guard
                    case .foreignKey(
                        let columns,
                        let table,
                        let referenced,
                        let onDelete,
                        _
                    ) = $0
                else { return false }
                guard case .cascade? = onDelete else { return false }
                return columns.map(\.name) == ["newsletter_id"]
                    && table == "newsletter_campaign"
                    && referenced.map(\.name) == ["id"]
            }
        )
        #expect(
            schema.indexes.map(\.name) == ["newsletter_subscriber_email_idx"]
        )
    }

    @Test
    func issueSchemaDefinesCampaignRelationAndUniqueCompositeKey() {
        let schema = Issue.Table.tableCreationSchema

        #expect(schema.name == "newsletter_issue")
        #expect(
            schema.constraints.contains {
                guard case .unique(let columns) = $0 else { return false }
                return columns.map(\.name) == ["id", "newsletter_id"]
            }
        )
        #expect(
            schema.constraints.contains {
                guard
                    case .foreignKey(
                        let columns,
                        let table,
                        let referenced,
                        _,
                        _
                    ) = $0
                else { return false }
                return columns.map(\.name) == ["newsletter_id"]
                    && table == "newsletter_campaign"
                    && referenced.map(\.name) == ["id"]
            }
        )
        #expect(
            schema.indexes.map(\.name) == ["newsletter_issue_newsletter_id_idx"]
        )
    }

    @Test
    func deliverySchemaDefinesCompositeKeysAndIndexes() {
        let schema = Delivery.Table.tableCreationSchema

        #expect(schema.name == "newsletter_delivery")
        #expect(
            schema.constraints.contains {
                guard case .primaryKey(let columns) = $0 else { return false }
                return columns.map(\.name) == ["issue_id", "subscriber_email"]
            }
        )
        #expect(
            schema.constraints.contains {
                guard
                    case .foreignKey(
                        let columns,
                        let table,
                        let referenced,
                        _,
                        _
                    ) = $0
                else { return false }
                return columns.map(\.name) == ["issue_id", "newsletter_id"]
                    && table == "newsletter_issue"
                    && referenced.map(\.name) == ["id", "newsletter_id"]
            }
        )
        #expect(
            schema.indexes.map(\.name) == [
                "newsletter_delivery_status_idx",
                "newsletter_delivery_issue_newsletter_id_idx",
            ]
        )
    }
}
