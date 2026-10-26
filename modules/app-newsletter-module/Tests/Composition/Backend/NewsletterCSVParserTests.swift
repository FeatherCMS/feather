import NewsletterModule
import Testing

@testable import NewsletterWebAdmin

@Suite
struct NewsletterCSVParserTests {

    private actor MockImportRepository:
        Campaign.Subscriber.Import.Repository.Interface
    {
        let knownEmails: Set<String>
        private(set) var createdRecords:
            [Campaign.Subscriber.Import.CSVParser.Record] = []

        init(knownEmails: Set<String>) {
            self.knownEmails = knownEmails
        }

        func existingEmails(newsletterId: String) async throws -> Set<String> {
            knownEmails
        }

        func create(
            newsletterId: String,
            record: Campaign.Subscriber.Import.CSVParser.Record
        ) async throws {
            createdRecords.append(record)
        }
    }

    @Test
    func parsesBOMQuotedEscapedAndMultilineFields() throws {
        let csv =
            "\u{FEFF}email,first_name,last_name,created_at\r\n"
            + "person@example.com,\"Ada, Éva\",\"Grace \"\"Amazing 🧬\"\" Hopper\",2026-01-01\r\n"
            + "multiline@example.com,\"Ada\r\nLovelace\",Byron,2026-01-02\r\n"

        let records = try Campaign.Subscriber.Import.CSVParser.parse(csv)

        #expect(records.count == 2)
        #expect(records[0].email == "person@example.com")
        #expect(records[0].firstName == "Ada, Éva")
        #expect(records[0].lastName == "Grace \"Amazing 🧬\" Hopper")
        #expect(records[1].email == "multiline@example.com")
        #expect(records[1].firstName == "Ada\r\nLovelace")
        #expect(records[1].lastName == "Byron")
    }

    @Test
    func parsesCMSSubscriberExportWithCreatedAtColumn() throws {
        let csv =
            "email,first_name,last_name,created_at\n"
            + "person-one@example.com,\"\",\"\",2022-01-16 17:54:14\n"
            + "person-two@example.com,\"\",\"\",2022-01-16 17:54:14\n"

        let records = try Campaign.Subscriber.Import.CSVParser.parse(csv)

        #expect(records.count == 2)
        #expect(
            records.map(\.email) == [
                "person-one@example.com",
                "person-two@example.com",
            ]
        )
        #expect(
            records.allSatisfy { $0.firstName.isEmpty && $0.lastName.isEmpty }
        )
    }

    @Test
    func parsesOptionalStatusAndDefaultsBlankStatus() throws {
        let records = try Campaign.Subscriber.Import.CSVParser.parse(
            "email,status\nsubscribed@example.com,subscribed\nunsubscribed@example.com,unsubscribed\nblank@example.com,\n"
        )

        #expect(records.map(\.status) == ["subscribed", "unsubscribed", nil])
    }

    @Test
    func importsNewRecordsAndSkipsExistingAndRepeatedEmails() async throws {
        let repository = MockImportRepository(
            knownEmails: ["existing@example.com"]
        )
        let interactor = Campaign.Subscriber.Import.Interactor.Default(
            repository: repository
        )

        let result = try await interactor.run(
            newsletterId: "weekly",
            csv:
                "email,first_name\nexisting@example.com,Known\nnew@example.com,Ada\nNEW@example.com,Duplicate\n"
        )
        let createdRecords = await repository.createdRecords

        #expect(result.imported == 1)
        #expect(result.skipped == 2)
        #expect(createdRecords.map(\.email) == ["new@example.com"])
        #expect(createdRecords.first?.firstName == "Ada")
    }

    @Test
    func importsCMSSubscriberExportAndIgnoresCreatedAt() async throws {
        let repository = MockImportRepository(knownEmails: [])
        let interactor = Campaign.Subscriber.Import.Interactor.Default(
            repository: repository
        )

        let result = try await interactor.run(
            newsletterId: "weekly",
            csv:
                "email,first_name,last_name,created_at\n"
                + "person-one@example.com,\"\",\"\",2022-01-16 17:54:14\n"
                + "person-two@example.com,\"\",\"\",2022-01-16 17:54:14\n"
        )
        let createdRecords = await repository.createdRecords

        #expect(result.imported == 2)
        #expect(result.skipped == 0)
        #expect(
            createdRecords.map(\.email) == [
                "person-one@example.com",
                "person-two@example.com",
            ]
        )
    }

    @Test
    func rejectsMalformedEscapingAndColumnCounts() {
        #expect(
            throws: Campaign.Subscriber.Import.CSVParser.ParseError.malformed(
                line: 2
            )
        ) {
            try Campaign.Subscriber.Import.CSVParser.parse(
                "email,first_name\nperson@example.com,\"open\n"
            )
        }
        #expect(
            throws: Campaign.Subscriber.Import.CSVParser.ParseError
                .wrongColumnCount(line: 2)
        ) {
            try Campaign.Subscriber.Import.CSVParser.parse(
                "email,first_name\nperson@example.com\n"
            )
        }
    }
}
