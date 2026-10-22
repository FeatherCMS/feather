import FeatherApplication
import FeatherModuleKit
import FeatherTesting
import Foundation
import Testing
import WebApplication
import WebDomain
import WebModule

@Suite
struct ApplicationTestSuite {
    @Test
    func menuItemDetailReturnsQueryOutputWhenAuthorized() async throws {
        let output = MenuItem.Detail.Output(
            id: "item-id",
            menuId: "menu-id",
            label: "Home",
            url: "/",
            priority: 0,
            isBlank: false,
            permission: "",
            authentication: .any,
            notes: nil,
            createdAt: .now,
            updatedAt: .now
        )
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: MenuItem.Detail.Scope(
                menuItem: MenuItem.Detail.Query.Mock(result: output)
            )
        )
        let useCase = MenuItem.Detail.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            query: executor
        )

        let result = try await useCase.execute(
            subject: Subject(id: "test-subject"),
            input: .init(id: "item-id", menuId: "menu-id")
        )

        #expect(result.id == output.id)
        #expect(result.menuId == output.menuId)
    }

    @Test
    func menuItemDetailRejectsUnauthorizedSubject() async throws {
        let output = MenuItem.Detail.Output(
            id: "item-id",
            menuId: "menu-id",
            label: "Home",
            url: "/",
            priority: 0,
            isBlank: false,
            permission: "",
            authentication: .any,
            notes: nil,
            createdAt: .now,
            updatedAt: .now
        )
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: MenuItem.Detail.Scope(
                menuItem: MenuItem.Detail.Query.Mock(result: output)
            )
        )
        let useCase = MenuItem.Detail.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: false),
            query: executor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "test-subject"),
                input: .init(id: "item-id", menuId: "menu-id")
            )
        }
    }

    @Test
    func menuItemDetailRejectsItemFromDifferentMenu() async throws {
        let output = MenuItem.Detail.Output(
            id: "item-id",
            menuId: "other-menu-id",
            label: "Home",
            url: "/",
            priority: 0,
            isBlank: false,
            permission: "",
            authentication: .any,
            notes: nil,
            createdAt: .now,
            updatedAt: .now
        )
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: MenuItem.Detail.Scope(
                menuItem: MenuItem.Detail.Query.Mock(result: output)
            )
        )
        let useCase = MenuItem.Detail.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            query: executor
        )

        await #expect(throws: (any Swift.Error).self) {
            _ = try await useCase.execute(
                subject: Subject(id: "test-subject"),
                input: .init(id: "item-id", menuId: "menu-id")
            )
        }
    }

    @Test
    func menuListReturnsQueryOutputWhenAuthorized() async throws {
        let output = Menu.List.Output(items: [])
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Menu.List.Scope(menu: Menu.List.Query.Mock(result: output))
        )
        let useCase = Menu.List.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            query: executor
        )

        let result = try await useCase.execute(
            subject: Subject(id: "test-subject"),
            input: .init()
        )

        #expect(result.items.isEmpty)
    }

    @Test
    func menuListRejectsUnauthorizedSubject() async throws {
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Menu.List.Scope(
                menu: Menu.List.Query.Mock(result: .init(items: []))
            )
        )
        let useCase = Menu.List.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: false),
            query: executor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "test-subject"),
                input: .init()
            )
        }
    }
}
