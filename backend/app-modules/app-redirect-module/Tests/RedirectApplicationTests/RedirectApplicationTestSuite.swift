import Testing
import Application
import Domain
import struct Foundation.Date
import RedirectDomain
@testable import RedirectApplication

@Suite
struct RedirectApplicationTestSuite {

    @Test
    func addRuleSuccess() async throws {
        let repository = RuleMockRepository(
            result: .success(makeRule(id: "v-1"))
        )
        let transaction = MockTransactionExecutor(
            context: WriteRule(rule: repository)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = AddRule(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: FixedIDGenerator(id: "generated-id")
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-1"),
            input: AddRule.Input(
                source: "/old-path",
                destination: "/new-path",
                statusCode: 301,
                notes: "permanent redirect"
            )
        )

        let createInput = await repository.lastCreateInput

        #expect(result.id == "v-1")
        #expect(createInput?.id == "generated-id")
        #expect(createInput?.source == "/old-path")
        #expect(createInput?.destination == "/new-path")
        #expect(createInput?.statusCode == 301)
        #expect(createInput?.notes == "permanent redirect")
        #expect(await authorizer.canCallCount == 1)
        #expect(await transaction.runCallCount == 1)
        #expect(await repository.createCallCount == 1)
    }

    @Test
    func addRuleForbidden() async throws {
        let repository = RuleMockRepository(
            result: .success(makeRule(id: "v-1"))
        )
        let transaction = MockTransactionExecutor(
            context: WriteRule(rule: repository)
        )
        let authorizer = MockAuthorizer(result: false)
        let useCase = AddRule(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: FixedIDGenerator(id: "generated-id")
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-1"),
                input: AddRule.Input(
                    source: "/old-path",
                    destination: "/new-path",
                    statusCode: 302,
                    notes: "temporary redirect"
                )
            )
        }
        #expect(await transaction.runCallCount == 0)
        #expect(await repository.createCallCount == 0)
    }

    @Test
    func getRuleSuccess() async throws {
        let queries = RuleMockQueries(
            findResult: makeRuleDetail(id: "v-1"),
            listResult: .init(items: []),
            countResult: 0
        )
        let queryExecutor = MockQueryExecutor(
            context: ReadRule(rule: queries)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = GetRule(
            authorizer: authorizer,
            query: queryExecutor
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-2"),
            input: GetRule.Input(id: "v-1")
        )

        #expect(result.id == "v-1")
        #expect(result.source == "/source-v-1")
        #expect(await queries.findCallCount == 1)
        #expect(await queries.lastFindId == "v-1")
    }

    @Test
    func listRulesAndCountSuccess() async throws {
        let listQuery = RuleList.Query(
            page: .init(size: 10, number: 2),
            sort: [.init(field: .source, direction: .asc)],
            search: "needle"
        )
        let queries = RuleMockQueries(
            findResult: makeRuleDetail(id: "v-2"),
            listResult: .init(items: [makeRuleListItem(id: "v-2")]),
            countResult: 42
        )
        let queryExecutor = MockQueryExecutor(
            context: ReadRule(rule: queries)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = ListRules(
            authorizer: authorizer,
            query: queryExecutor
        )

        let list = try await useCase.execute(
            subject: Subject(id: "subject-2"),
            input: ListRules.Input(query: listQuery)
        )
        let count = try await useCase.count(
            subject: Subject(id: "subject-2"),
            input: ListRules.Input(query: listQuery)
        )

        #expect(list.items.count == 1)
        #expect(list.items.first?.destination == "/destination-v-2")
        #expect(count == 42)
        #expect(await queryExecutor.runCallCount == 2)
        #expect(await queries.listCallCount == 1)
        #expect(await queries.countCallCount == 1)
    }

    @Test
    func getPublicRuleBySourceSuccess() async throws {
        let queries = RuleMockQueries(
            findResult: makeRuleDetail(id: "v-2"),
            findBySourceResult: makeRuleDetail(id: "public-1"),
            listResult: .init(items: []),
            countResult: 0
        )
        let queryExecutor = MockQueryExecutor(
            context: ReadRule(rule: queries)
        )
        let useCase = GetPublicRuleBySource(query: queryExecutor)

        let result = try await useCase.execute(source: "/from-here/")

        #expect(result.source == "/source-public-1")
        #expect(result.destination == "/destination-public-1")
        #expect(result.statusCode == 301)
        #expect(await queries.findBySourceCallCount == 1)
        #expect(await queries.lastFindSource == "/from-here/")
    }

    @Test
    func editRuleSuccess() async throws {
        let repository = RuleMockRepository(
            result: .success(makeRule(id: "v-3")),
            findResult: makeRule(id: "v-3")
        )
        let transaction = MockTransactionExecutor(
            context: WriteRule(rule: repository)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = EditRule(
            authorizer: authorizer,
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-3"),
            input: EditRule.Input(
                id: "v-3",
                source: "/updated-source",
                destination: "/updated-destination",
                statusCode: 308,
                notes: "updated notes"
            )
        )

        #expect(result.id == "v-3")
        #expect(result.source == "/updated-source")
        #expect(result.destination == "/updated-destination")
        #expect(result.statusCode == 308)
        #expect(await repository.findCallCount == 1)
        #expect(await repository.updateCallCount == 1)
    }

    @Test
    func removeRuleForbidden() async throws {
        let repository = RuleMockRepository(
            result: .success(makeRule(id: "v-4")),
            deleteResult: true
        )
        let transaction = MockTransactionExecutor(
            context: WriteRule(rule: repository)
        )
        let authorizer = MockAuthorizer(result: false)
        let useCase = RemoveRule(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-4"),
                input: RemoveRule.Input(id: "v-4")
            )
        }
        #expect(await repository.deleteCallCount == 0)
    }

    @Test
    func removeRuleSuccess() async throws {
        let repository = RuleMockRepository(
            result: .success(makeRule(id: "v-5")),
            deleteResult: true
        )
        let transaction = MockTransactionExecutor(
            context: WriteRule(rule: repository)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = RemoveRule(
            authorizer: authorizer,
            transaction: transaction
        )

        let deleted = try await useCase.execute(
            subject: Subject(id: "subject-5"),
            input: RemoveRule.Input(id: "v-5")
        )

        #expect(deleted)
        #expect(await repository.deleteCallCount == 1)
        #expect(await repository.lastDeleteId == "v-5")
    }
}

private func makeRule(
    id: String
) -> Rule {
    .init(
        id: id,
        source: "/source-\(id)",
        destination: "/destination-\(id)",
        statusCode: 302,
        notes: "valid-notes",
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeRuleDetail(
    id: String
) -> RuleDetail {
    .init(
        id: id,
        source: "/source-\(id)",
        destination: "/destination-\(id)",
        statusCode: 301,
        notes: "valid-notes",
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeRuleListItem(
    id: String
) -> RuleList.Item {
    .init(
        id: id,
        source: "/source-\(id)",
        destination: "/destination-\(id)",
        statusCode: 307,
        notes: "notes-\(id)",
        createdAt: Date(),
        updatedAt: Date()
    )
}
