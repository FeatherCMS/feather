import AccountModule
import FeatherApplication
import FeatherMail
import FeatherModuleKit
import FeatherTesting
import Foundation
import SystemApplication
import Testing
import UserApplication
import UserModule

@testable import AccountApplication
@testable import AccountDomain
@testable import UserDomain

//
//  AccountApplication+UseCases+Tests.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

@Suite
struct AccountApplicationUseCasesTests {

    @Test
    func listInvitationsUsesUnfilteredListQuery() async throws {
        let queries = MockInvitationQueries(listResult: .init(items: []))
        let useCase = Invitation.List.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            query: FeatherTesting.QueryExecutor.Mock(
                context: Invitation.List.Scope(query: queries)
            )
        )

        let result = try await useCase.execute(
            subject: .init(id: "admin-1"),
            input: .init()
        )

        #expect(result.items.isEmpty)
        #expect(await queries.listCallCount == 1)
        #expect(await queries.searchCallCount == 0)
    }

    @Test
    func searchInvitationsUsesStructuredSearchQuery() async throws {
        let queries = MockInvitationQueries(
            listResult: .init(items: []),
            searchResult: .init(items: [], total: 7)
        )
        let useCase = Invitation.Search.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            query: FeatherTesting.QueryExecutor.Mock(
                context: Invitation.Search.Scope(query: queries)
            )
        )

        let result = try await useCase.execute(
            subject: .init(id: "admin-1"),
            input: .init(query: .init())
        )

        #expect(result.total == 7)
        #expect(await queries.listCallCount == 0)
        #expect(await queries.searchCallCount == 1)
    }

    @Test
    func exposesAccountProfilePermissions() {
        #expect(
            Profile.Permissions.allPermissions() == [
                Profile.Permissions.create,
                Profile.Permissions.read,
                Profile.Permissions.update,
            ]
        )
        #expect(
            AccountModule.Permissions.allPermissions()
                .contains(
                    Profile.Permissions.read
                )
        )
        #expect(
            AccountModule.Permissions.allPermissions()
                .contains(
                    Profile.Permissions.update
                )
        )
    }

    @Test
    func validateInvitationReturnsUnexpiredInvitation() async throws {
        let invitation = Invitation.Detail.Output(
            id: "invitation-1",
            userId: "user-1",
            email: "user@example.com",
            token: "token-123456",
            roleIDs: ["role-editor", "role-admin"],
            expiresAt: Date().addingTimeInterval(3600),
            createdAt: Date(),
            updatedAt: Date()
        )
        let queries = MockInvitationQueries(
            listResult: .init(items: []),
            tokenResult: invitation
        )
        let useCase = Invitation.Validate.UseCase(
            query: FeatherTesting.QueryExecutor.Mock(
                context: Invitation.Validate.Scope(query: queries)
            )
        )

        let result = try await useCase.execute(
            input: .init(token: invitation.token)
        )

        #expect(result.email == invitation.email)
        #expect(result.roleIDs == invitation.roleIDs)
    }

    @Test
    func validateInvitationRejectsExpiredInvitation() async throws {
        let invitation = Invitation.Detail.Output(
            id: "invitation-1",
            userId: "user-1",
            email: "user@example.com",
            token: "token-123456",
            expiresAt: Date().addingTimeInterval(-1),
            createdAt: Date(),
            updatedAt: Date()
        )
        let queries = MockInvitationQueries(
            listResult: .init(items: []),
            tokenResult: invitation
        )
        let useCase = Invitation.Validate.UseCase(
            query: FeatherTesting.QueryExecutor.Mock(
                context: Invitation.Validate.Scope(query: queries)
            )
        )

        await #expect(throws: Invitation.Validate.Error.self) {
            _ = try await useCase.execute(input: .init(token: invitation.token))
        }
    }

    @Test
    func completesInvitationRegistrationTransactionally() async throws {
        let invitation = Invitation.Model(
            id: "invitation-1",
            userId: "user-1",
            email: "user@example.com",
            token: "token-123456",
            roleIDs: ["role-editor"],
            expiresAt: Date().addingTimeInterval(3600),
            createdAt: Date(),
            updatedAt: Date()
        )
        let identity = Identity.Model(
            id: "user-1",
            status: .invited,
            isRoot: false,
            createdAt: Date(),
            updatedAt: Date()
        )
        let invitationRepository = MockInvitationRepository(
            result: invitation,
            findByTokenResult: invitation,
            deleteResult: true
        )
        let identityRepository = MockIdentityRepository(identity: identity)
        let authEmailRepository = MockAuthEmailRepository()
        let credentialWriter = MockInvitationCredentialWriter()
        let transaction = MockContextualTransactionExecutor(
            context: Invitation.CompleteRegistration.Scope(
                invitation: invitationRepository,
                identity: identityRepository,
                authEmail: authEmailRepository,
                credential: credentialWriter
            )
        )
        let useCase = Invitation.CompleteRegistration.UseCase(
            transaction: transaction
        )

        let result = try await useCase.execute(
            input: .init(token: invitation.token, password: "password-123")
        )

        #expect(result.id == identity.id)
        #expect(result.status == .active)
        #expect(result.roleIds == invitation.roleIDs)
        #expect(await credentialWriter.createCallCount == 1)
        #expect(await authEmailRepository.insertCallCount == 1)
        #expect(await identityRepository.replacedRoleIds == invitation.roleIDs)
        #expect(await identityRepository.updateCallCount == 1)
        #expect(await invitationRepository.deleteCallCount == 1)
        #expect(await transaction.runCallCount == 1)
    }

    @Test
    func addInvitationRejectsUnknownRole() async throws {
        let identity = Identity.Model(
            id: "user-1",
            status: .invited,
            isRoot: false,
            createdAt: Date(),
            updatedAt: Date()
        )
        let identityRepository = MockIdentityRepository(identity: identity)
        let transaction = MockContextualTransactionExecutor(
            context: Invitation.Add.Scope(
                invitation: MockInvitationRepository(
                    result: Invitation.Model(
                        id: "invitation-1",
                        userId: identity.id,
                        email: "user@example.com",
                        token: "token-123456",
                        roleIDs: [],
                        expiresAt: Date().addingTimeInterval(3600),
                        createdAt: Date(),
                        updatedAt: Date()
                    )
                ),
                identity: identityRepository,
                role: MockRoleRepository(),
                authEmail: MockAuthEmailRepository(),
                variable: MockVariableLookup(value: "https://example.test")
            )
        )
        let useCase = Invitation.Add.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            transaction: transaction,
            events: MockEventPublisher(),
            jobs: MockSendMailJobController()
        )

        await #expect(throws: Invitation.Add.Error.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "admin-1"),
                input: .init(email: "user@example.com", roleIDs: ["missing"])
            )
        }
    }

    @Test
    func addInvitationEmailContainsResolvedURL() async throws {
        let identity = Identity.Model(
            id: "user-1",
            status: .invited,
            isRoot: false,
            createdAt: Date(),
            updatedAt: Date()
        )
        let token = "token-123456"
        let authEmailRepository = MockAuthEmailRepository()
        let invitationRepository = MockInvitationRepository(
            result: Invitation.Model(
                id: "invitation-1",
                userId: identity.id,
                email: "user@example.com",
                token: token,
                roleIDs: [],
                expiresAt: Date().addingTimeInterval(3600),
                createdAt: Date(),
                updatedAt: Date()
            )
        )
        let transaction = MockContextualTransactionExecutor(
            context: Invitation.Add.Scope(
                invitation: invitationRepository,
                identity: MockIdentityRepository(identity: identity),
                role: MockRoleRepository(),
                authEmail: authEmailRepository,
                variable: MockVariableLookup(
                    value: "https://example.test",
                    mailFromAddress: "invitations@example.test",
                    mailFromName: "Binary Birds"
                )
            )
        )
        let jobs = MockSendMailJobController()
        let useCase = Invitation.Add.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            transaction: transaction,
            events: MockEventPublisher(),
            jobs: jobs
        )

        _ = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(email: "user@example.com", roleIDs: [])
        )

        #expect(
            await jobs.lastBody?
                .contains(
                    "https://example.test/account/invitation/accept/?token=\(token)"
                ) == true
        )
        #expect(
            await authEmailRepository.insertedEmails == ["user@example.com"]
        )
        #expect(
            await jobs.lastMail?.from.email
                == "invitations@example.test"
        )
        #expect(await jobs.lastMail?.from.name == "Binary Birds")
        #expect(await jobs.lastBody?.contains("\\(") == false)
    }

    @Test
    func removesAuthEmailWhenPendingInvitationIsRemoved() async throws {
        let invitation = Invitation.Model(
            id: "invitation-1",
            userId: "user-1",
            email: "user@example.com",
            token: "token-123456",
            roleIDs: [],
            expiresAt: Date().addingTimeInterval(3600),
            createdAt: Date(),
            updatedAt: Date()
        )
        let authEmailRepository = MockAuthEmailRepository()
        _ = try await authEmailRepository.insert(
            identityId: invitation.userId,
            email: invitation.email
        )
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: Invitation.Remove.Scope(
                invitation: MockInvitationRepository(
                    result: invitation,
                    deleteResult: true
                ),
                identity: MockIdentityRepository(
                    identity: Identity.Model(
                        id: invitation.userId,
                        status: .invited,
                        isRoot: false,
                        createdAt: Date(),
                        updatedAt: Date()
                    )
                ),
                authEmail: authEmailRepository
            )
        )
        let useCase = Invitation.Remove.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            transaction: transaction
        )

        let removedIDs = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(ids: [invitation.id])
        )

        #expect(removedIDs.ids == [invitation.id])
        #expect(await authEmailRepository.deleteCallCount == 1)
        #expect(await authEmailRepository.emailCount() == 0)
    }

    @Test
    func resendInvitationRenewsTokenAndSendsEmail() async throws {
        let invitation = Invitation.Model(
            id: "invitation-1",
            userId: "user-1",
            email: "user@example.com",
            token: "token-123456",
            roleIDs: ["role-editor"],
            expiresAt: Date().addingTimeInterval(60),
            createdAt: Date(),
            updatedAt: Date()
        )
        let repository = MockInvitationRepository(result: invitation)
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: Invitation.Resend.Scope(
                invitation: repository,
                variable: MockVariableLookup(
                    value: "https://example.test",
                    mailFromAddress: "resend@example.test",
                    mailFromName: "Binary Birds"
                )
            )
        )
        let jobs = MockSendMailJobController()
        let useCase = Invitation.Resend.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            transaction: transaction,
            jobs: jobs
        )

        let result = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(id: invitation.id)
        )

        #expect(result.id == invitation.id)
        #expect(result.token != invitation.token)
        #expect(await repository.updateCallCount == 1)
        #expect(await jobs.enqueueCallCount == 1)
        #expect(
            await jobs.lastMail?.from.email == "resend@example.test"
        )
        #expect(await jobs.lastMail?.from.name == "Binary Birds")
        #expect(
            await jobs.lastBody?
                .contains(
                    "This is a reminder for your application identity invitation."
                ) == true
        )
        #expect(
            await jobs.lastBody?.contains(result.token) == true
        )
    }

    @Test
    func completeInvitationRegistrationRejectsNonInvitedIdentity()
        async throws
    {
        let invitation = Invitation.Model(
            id: "invitation-1",
            userId: "user-1",
            email: "user@example.com",
            token: "token-123456",
            roleIDs: [],
            expiresAt: Date().addingTimeInterval(3600),
            createdAt: Date(),
            updatedAt: Date()
        )
        let identity = Identity.Model(
            id: "user-1",
            status: .active,
            isRoot: false,
            createdAt: Date(),
            updatedAt: Date()
        )
        let credentialWriter = MockInvitationCredentialWriter()
        let transaction = MockContextualTransactionExecutor(
            context: Invitation.CompleteRegistration.Scope(
                invitation: MockInvitationRepository(
                    result: invitation,
                    findByTokenResult: invitation
                ),
                identity: MockIdentityRepository(identity: identity),
                authEmail: MockAuthEmailRepository(),
                credential: credentialWriter
            )
        )
        let useCase = Invitation.CompleteRegistration.UseCase(
            transaction: transaction
        )

        await #expect(
            throws: Invitation.CompleteRegistration.Error.self
        ) {
            _ = try await useCase.execute(
                input: .init(token: invitation.token, password: "password-123")
            )
        }

        #expect(await credentialWriter.createCallCount == 0)
    }

    @Test
    func resendInvitationRequiresCreatePermission() async throws {
        let repository = MockInvitationRepository(
            result: Invitation.Model(
                id: "invitation-1",
                userId: "user-1",
                email: "user@example.com",
                token: "token-123456",
                roleIDs: [],
                expiresAt: Date().addingTimeInterval(3600),
                createdAt: Date(),
                updatedAt: Date()
            )
        )
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: Invitation.Resend.Scope(
                invitation: repository,
                variable: MockVariableLookup(value: "https://example.test")
            )
        )
        let useCase = Invitation.Resend.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: false),
            transaction: transaction,
            jobs: MockSendMailJobController()
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "admin-1"),
                input: .init(id: "invitation-1")
            )
        }

        #expect(await transaction.runCallCount == 0)
    }

    @Test
    func getAccountProfileReturnsOwnProfile() async throws {
        let profile = makeAccountProfile()
        let repository = MockAccountProfileRepository(result: profile)
        let query = FeatherTesting.QueryExecutor.Mock(
            context: Profile.Detail.Scope(query: repository)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Profile.Detail.UseCase(
            authorizer: authorizer,
            query: query
        )

        let result = try await useCase.execute(
            subject: Subject(id: profile.userId),
            input: .init()
        )

        #expect(result.userId == profile.userId)
        #expect(result.firstName == profile.firstName)
        #expect(result.lastName == profile.lastName)
        #expect(await repository.findCallCount == 1)
        #expect(await repository.requestedUserIds == [profile.userId])
        #expect(await query.runCallCount == 1)
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func getAccountProfileAllowsOwnProfileWhenAuthorized() async throws {
        let profile = makeAccountProfile()
        let repository = MockAccountProfileRepository(result: profile)
        let query = FeatherTesting.QueryExecutor.Mock(
            context: Profile.Detail.Scope(query: repository)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Profile.Detail.UseCase(
            authorizer: authorizer,
            query: query
        )

        _ = try await useCase.execute(
            subject: Subject(id: profile.userId),
            input: .init()
        )

        #expect(await repository.findCallCount == 1)
        #expect(await query.runCallCount == 1)
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func getAccountProfileReadsTargetUserWithReadPermission() async throws {
        let profile = makeAccountProfile()
        let repository = MockAccountProfileRepository(result: profile)
        let query = FeatherTesting.QueryExecutor.Mock(
            context: Profile.Detail.Scope(query: repository)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Profile.Detail.UseCase(
            authorizer: authorizer,
            query: query
        )

        _ = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(userId: profile.userId)
        )

        #expect(await repository.requestedUserIds == [profile.userId])
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func getAccountProfileDoesNotReadTargetUserWithoutPermission() async throws
    {
        let profile = makeAccountProfile()
        let repository = MockAccountProfileRepository(result: profile)
        let query = FeatherTesting.QueryExecutor.Mock(
            context: Profile.Detail.Scope(query: repository)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = Profile.Detail.UseCase(
            authorizer: authorizer,
            query: query
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "admin-1"),
                input: .init(userId: profile.userId)
            )
        }

        #expect(await repository.requestedUserIds.isEmpty)
        #expect(await query.runCallCount == 0)
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func profileActionsAllowOwnerAndRequirePermissionForOtherUsers()
        async throws
    {
        let owner = Subject(id: "user-1")
        let ownRead = try await Profile.Detail.Action(userID: owner.id)
            .authorize(subject: owner, permissions: [])
        let otherRead = try await Profile.Detail.Action(userID: "user-2")
            .authorize(subject: owner, permissions: [])
        let permittedRead = try await Profile.Detail.Action(userID: "user-2")
            .authorize(
                subject: owner,
                permissions: [Profile.Permissions.read]
            )
        let ownEdit = try await Profile.Edit.Action(userID: owner.id)
            .authorize(subject: owner, permissions: [])
        let otherEdit = try await Profile.Edit.Action(userID: "user-2")
            .authorize(subject: owner, permissions: [])
        let permittedEdit = try await Profile.Edit.Action(userID: "user-2")
            .authorize(
                subject: owner,
                permissions: [Profile.Permissions.update]
            )

        #expect(ownRead)
        #expect(!otherRead)
        #expect(permittedRead)
        #expect(ownEdit)
        #expect(!otherEdit)
        #expect(permittedEdit)
    }

    @Test
    func editAccountProfilePersistsTargetUserWithUpdatePermission() async throws
    {
        let profile = makeAccountProfile()
        let repository = MockAccountProfileRepository(result: profile)
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: Profile.Edit.Scope(profile: repository)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Profile.Edit.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(
                firstName: "Grace",
                lastName: "Hopper",
                profileImageAssetId: nil,
                userId: profile.userId
            )
        )

        #expect(result.userId == profile.userId)
        #expect(result.firstName == "Grace")
        #expect(await repository.requestedUserIds == [profile.userId])
        #expect(await repository.updateCallCount == 1)
        #expect(await transaction.runCallCount == 1)
    }

    @Test
    func editAccountProfileDoesNotWriteTargetUserWhenForbidden()
        async throws
    {
        let profile = makeAccountProfile()
        let repository = MockAccountProfileRepository(result: profile)
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: Profile.Edit.Scope(profile: repository)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = Profile.Edit.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "admin-1"),
                input: .init(
                    firstName: "Grace",
                    lastName: "Hopper",
                    profileImageAssetId: nil,
                    userId: profile.userId
                )
            )
        }

        #expect(await repository.updateCallCount == 0)
        #expect(await transaction.runCallCount == 0)
    }

    @Test
    func editAccountProfilePersistsValidatedChanges() async throws {
        let profile = makeAccountProfile()
        let repository = MockAccountProfileRepository(result: profile)
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: Profile.Edit.Scope(profile: repository)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Profile.Edit.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: profile.userId),
            input: .init(
                firstName: "Grace",
                lastName: "Hopper",
                profileImageAssetId: "asset-grace"
            )
        )

        #expect(result.firstName == "Grace")
        #expect(result.lastName == "Hopper")
        #expect(await repository.updateCallCount == 1)
        #expect(await repository.updatedModel?.firstName == "Grace")
        #expect(await repository.updatedModel?.lastName == "Hopper")
        #expect(await transaction.runCallCount == 1)
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func editAccountProfileAllowsOwnProfileWhenAuthorized() async throws {
        let profile = makeAccountProfile()
        let repository = MockAccountProfileRepository(result: profile)
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: Profile.Edit.Scope(profile: repository)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Profile.Edit.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: profile.userId),
            input: .init(
                firstName: "Grace",
                lastName: "Hopper",
                profileImageAssetId: nil
            )
        )

        #expect(result.userId == profile.userId)
        #expect(await repository.updateCallCount == 1)
        #expect(await transaction.runCallCount == 1)
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func editAccountProfileDoesNotPersistInvalidNames() async throws {
        let repository = MockAccountProfileRepository(
            result: makeAccountProfile()
        )
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: Profile.Edit.Scope(profile: repository)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Profile.Edit.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: Profile.Model.Error.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "account-1"),
                input: .init(
                    firstName: String(repeating: "A", count: 256),
                    lastName: "Lovelace",
                    profileImageAssetId: nil
                )
            )
        }

        #expect(await repository.updateCallCount == 0)
        #expect(await transaction.runCallCount == 1)
    }

    @Test
    func exposesAllSettingsPermissions() {
        let settingsPermissions = Settings.Permissions
            .allPermissions()
        let allPermissions = AccountModule.Permissions.allPermissions()

        #expect(
            settingsPermissions == [
                Settings.Permissions.read,
                Settings.Permissions.update,
            ]
        )
        #expect(
            allPermissions
                == Profile.Permissions.allPermissions()
                .union(settingsPermissions)
                .union(Invitation.Permissions.allPermissions())
        )
    }

    @Test
    func getSettingsReadsTargetUserWithReadPermission() async throws {
        let settings = makeSettings()
        let repository = MockSettingsRepository(result: settings)
        let query = FeatherTesting.QueryExecutor.Mock(
            context: Settings.Detail.Scope(query: repository)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Settings.Detail.UseCase(
            authorizer: authorizer,
            query: query
        )

        _ = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(userId: settings.userId)
        )

        #expect(await repository.findCallCount == 1)
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func getSettingsReturnsMappedDetailForAuthorizedSubject() async throws {
        let settings = makeSettings()
        let repository = MockSettingsRepository(result: settings)
        let query = FeatherTesting.QueryExecutor.Mock(
            context: Settings.Detail.Scope(query: repository)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Settings.Detail.UseCase(
            authorizer: authorizer,
            query: query
        )

        let result = try await useCase.execute(
            subject: Subject(id: settings.userId),
            input: .init()
        )

        #expect(result.userId == settings.userId)
        #expect(result.language == settings.language)
        #expect(result.timezone == settings.timezone)
        #expect(result.pageSize == settings.pageSize)
        #expect(await repository.findCallCount == 1)
        #expect(await query.runCallCount == 1)
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func getSettingsDoesNotQueryForForbiddenSubject() async throws {
        let settings = makeSettings()
        let repository = MockSettingsRepository(result: settings)
        let query = FeatherTesting.QueryExecutor.Mock(
            context: Settings.Detail.Scope(query: repository)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = Settings.Detail.UseCase(
            authorizer: authorizer,
            query: query
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "admin-1"),
                input: .init(userId: settings.userId)
            )
        }

        #expect(await repository.findCallCount == 0)
        #expect(await query.runCallCount == 0)
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func editSettingsUpdatesAndReturnsMappedDetailForAuthorizedSubject()
        async throws
    {
        let settings = makeSettings()
        let repository = MockSettingsRepository(result: settings)
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: Settings.Edit.Scope(settings: repository)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Settings.Edit.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: settings.userId),
            input: .init(
                language: "de",
                timezone: "Europe/Berlin",
                pageSize: 50
            )
        )

        #expect(result.language == "de")
        #expect(result.timezone == "Europe/Berlin")
        #expect(result.pageSize == 50)
        #expect(await repository.getCallCount == 1)
        #expect(await repository.updateCallCount == 1)
        #expect(await repository.updatedModel?.language == "de")
        #expect(await repository.updatedModel?.timezone == "Europe/Berlin")
        #expect(await repository.updatedModel?.pageSize == 50)
        #expect(await transaction.runCallCount == 1)
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func editSettingsDoesNotWriteForForbiddenSubject() async throws {
        let settings = makeSettings()
        let repository = MockSettingsRepository(result: settings)
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: Settings.Edit.Scope(settings: repository)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = Settings.Edit.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "admin-1"),
                input: .init(
                    language: "de",
                    timezone: "Europe/Berlin",
                    pageSize: 50,
                    userId: settings.userId
                )
            )
        }

        #expect(await transaction.runCallCount == 0)
        #expect(await repository.updateCallCount == 0)
        #expect(await authorizer.canCallCount == 1)
    }

    private func makeSettings() -> Settings.Model {
        Settings.Model(
            userId: "account-1",
            language: "en",
            timezone: "UTC",
            pageSize: 20,
            createdAt: Date(timeIntervalSince1970: 1),
            updatedAt: Date(timeIntervalSince1970: 2)
        )
    }

    private func makeAccountProfile() -> Profile.Model {
        Profile.Model(
            userId: "account-1",
            firstName: "Ada",
            lastName: "Lovelace",
            profileImageAssetId: nil,
            createdAt: Date(timeIntervalSince1970: 1),
            updatedAt: Date(timeIntervalSince1970: 2)
        )
    }
}
