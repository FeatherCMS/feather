import AccountContracts
import FeatherApplication
import FeatherContracts
import Foundation
import SystemApplication
import Testing

@testable import AccountApplication
@testable import AccountDomain
@testable import UserDomain
import UserApplication

//
//  AccountApplicationTestSuite.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

@Suite
struct AccountApplicationTestSuite {

    @Test
    func exposesAccountProfilePermissions() {
        #expect(
            AccountPermissions.Profile.allPermissions() == [
                AccountPermissions.Profile.read,
                AccountPermissions.Profile.update,
                AccountPermissions.Profile.manage,
            ]
        )
        #expect(
            AccountPermissions.allPermissions().contains(
                AccountPermissions.Profile.read
            )
        )
    }

    @Test
    func validateInvitationReturnsUnexpiredInvitation() async throws {
        let invitation = InvitationDetail(
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
            countResult: 0,
            tokenResult: invitation
        )
        let useCase = ValidateInvitation(
            query: MockQueryExecutor(context: ReadInvitation(invitation: queries))
        )

        let result = try await useCase.execute(
            input: .init(token: invitation.token)
        )

        #expect(result.email == invitation.email)
        #expect(result.roleIDs == invitation.roleIDs)
    }

    @Test
    func validateInvitationRejectsExpiredInvitation() async throws {
        let invitation = InvitationDetail(
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
            countResult: 0,
            tokenResult: invitation
        )
        let useCase = ValidateInvitation(
            query: MockQueryExecutor(context: ReadInvitation(invitation: queries))
        )

        await #expect(throws: ValidateInvitation.Error.self) {
            _ = try await useCase.execute(input: .init(token: invitation.token))
        }
    }

    @Test
    func completesInvitationRegistrationTransactionally() async throws {
        let invitation = Invitation(
            id: "invitation-1",
            userId: "user-1",
            email: "user@example.com",
            token: "token-123456",
            roleIDs: ["role-editor"],
            expiresAt: Date().addingTimeInterval(3600),
            createdAt: Date(),
            updatedAt: Date()
        )
        let identity = Identity(
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
        let credentialWriter = MockInvitationCredentialWriter()
        let transaction = MockContextualTransactionExecutor(
            context: WriteInvitation(
                invitation: invitationRepository,
                identity: identityRepository,
                role: MockRoleRepository(),
                credential: credentialWriter
            )
        )
        let useCase = CompleteInvitationRegistration(transaction: transaction)

        let result = try await useCase.execute(
            input: .init(token: invitation.token, password: "password-123")
        )

        #expect(result.id == identity.id)
        #expect(result.status == .active)
        #expect(result.roleIds == invitation.roleIDs)
        #expect(await credentialWriter.createCallCount == 1)
        #expect(await identityRepository.replacedRoleIds == invitation.roleIDs)
        #expect(await identityRepository.updateCallCount == 1)
        #expect(await invitationRepository.deleteCallCount == 1)
        #expect(await transaction.runCallCount == 1)
    }

    @Test
    func addInvitationRejectsUnknownRole() async throws {
        let identity = Identity(
            id: "user-1",
            status: .invited,
            isRoot: false,
            createdAt: Date(),
            updatedAt: Date()
        )
        let identityRepository = MockIdentityRepository(identity: identity)
        let transaction = MockContextualTransactionExecutor(
            context: WriteInvitationWithVariable(
                invitation: MockInvitationRepository(
                    result: Invitation(
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
                credential: MockInvitationCredentialWriter(),
                variable: MockVariableQueries(value: "https://example.test")
            )
        )
        let useCase = AddInvitation(
            authorizer: MockPermissionAuthorizer(
                permissions: [AccountPermissions.Invitations.create]
            ),
            transaction: transaction,
            events: MockEventPublisher(),
            mailSender: MockMailSender()
        )

        await #expect(throws: AddInvitation.Error.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "admin-1"),
                input: .init(email: "user@example.com", roleIDs: ["missing"])
            )
        }
    }

    @Test
    func addInvitationEmailContainsResolvedURL() async throws {
        let identity = Identity(
            id: "user-1",
            status: .invited,
            isRoot: false,
            createdAt: Date(),
            updatedAt: Date()
        )
        let token = "token-123456"
        let invitationRepository = MockInvitationRepository(
            result: Invitation(
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
            context: WriteInvitationWithVariable(
                invitation: invitationRepository,
                identity: MockIdentityRepository(identity: identity),
                role: MockRoleRepository(),
                credential: MockInvitationCredentialWriter(),
                variable: MockVariableQueries(value: "https://example.test")
            )
        )
        let mailSender = MockMailSender()
        let useCase = AddInvitation(
            authorizer: MockPermissionAuthorizer(
                permissions: [AccountPermissions.Invitations.create]
            ),
            transaction: transaction,
            events: MockEventPublisher(),
            mailSender: mailSender
        )

        _ = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(email: "user@example.com", roleIDs: [])
        )

        #expect(
            await mailSender.lastMessage?.body.contains(
                "https://example.test/account/invitation/accept/?token=\(token)"
            ) == true
        )
        #expect(await mailSender.lastMessage?.body.contains("\\(") == false)
    }

    @Test
    func resendInvitationRenewsTokenAndSendsEmail() async throws {
        let invitation = Invitation(
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
        let transaction = MockTransactionExecutor(
            context: WriteInvitationOnlyWithVariable(
                invitation: repository,
                role: MockRoleRepository(),
                variable: MockVariableQueries(value: "https://example.test")
            )
        )
        let mailSender = MockMailSender()
        let useCase = ResendInvitation(
            authorizer: MockPermissionAuthorizer(
                permissions: [AccountPermissions.Invitations.create]
            ),
            transaction: transaction,
            mailSender: mailSender
        )

        let result = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(id: invitation.id)
        )

        #expect(result.id == invitation.id)
        #expect(result.token != invitation.token)
        #expect(await repository.updateCallCount == 1)
        #expect(await mailSender.sendCallCount == 1)
        #expect(
            await mailSender.lastMessage?.body.contains(
                "This is a reminder for your application identity invitation."
            ) == true
        )
        #expect(await mailSender.lastMessage?.body.contains(result.token) == true)
    }

    @Test
    func completeInvitationRegistrationRejectsNonInvitedIdentity()
        async throws
    {
        let invitation = Invitation(
            id: "invitation-1",
            userId: "user-1",
            email: "user@example.com",
            token: "token-123456",
            roleIDs: [],
            expiresAt: Date().addingTimeInterval(3600),
            createdAt: Date(),
            updatedAt: Date()
        )
        let identity = Identity(
            id: "user-1",
            status: .active,
            isRoot: false,
            createdAt: Date(),
            updatedAt: Date()
        )
        let credentialWriter = MockInvitationCredentialWriter()
        let transaction = MockContextualTransactionExecutor(
            context: WriteInvitation(
                invitation: MockInvitationRepository(
                    result: invitation,
                    findByTokenResult: invitation
                ),
                identity: MockIdentityRepository(identity: identity),
                role: MockRoleRepository(),
                credential: credentialWriter
            )
        )
        let useCase = CompleteInvitationRegistration(transaction: transaction)

        await #expect(throws: CompleteInvitationRegistration.Error.self) {
            _ = try await useCase.execute(
                input: .init(token: invitation.token, password: "password-123")
            )
        }

        #expect(await credentialWriter.createCallCount == 0)
    }

    @Test
    func resendInvitationRequiresCreatePermission() async throws {
        let repository = MockInvitationRepository(
            result: Invitation(
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
        let transaction = MockTransactionExecutor(
            context: WriteInvitationOnlyWithVariable(
                invitation: repository,
                role: MockRoleRepository(),
                variable: MockVariableQueries(value: "https://example.test")
            )
        )
        let useCase = ResendInvitation(
            authorizer: MockPermissionAuthorizer(permissions: []),
            transaction: transaction,
            mailSender: MockMailSender()
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
        let query = MockQueryExecutor(
            context: ReadAccountProfile(profile: repository)
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [AccountPermissions.Profile.read]
        )
        let useCase = GetAccountProfile(authorizer: authorizer, query: query)

        let result = try await useCase.execute(
            subject: Subject(id: profile.userId),
            input: .init()
        )

        #expect(result.userId == profile.userId)
        #expect(result.firstName == profile.firstName)
        #expect(result.lastName == profile.lastName)
        #expect(await repository.getCallCount == 1)
        #expect(await repository.requestedUserIds == [profile.userId])
        #expect(await query.runCallCount == 1)
    }

    @Test
    func getAccountProfileDoesNotReadWithoutPermission() async throws {
        let repository = MockAccountProfileRepository(result: makeAccountProfile())
        let query = MockQueryExecutor(
            context: ReadAccountProfile(profile: repository)
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [AccountPermissions.Profile.update]
        )
        let useCase = GetAccountProfile(authorizer: authorizer, query: query)

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "account-1"),
                input: .init()
            )
        }

        #expect(await repository.getCallCount == 0)
        #expect(await query.runCallCount == 0)
    }

    @Test
    func getAccountProfileReadsTargetUserWithManagePermission() async throws {
        let profile = makeAccountProfile()
        let repository = MockAccountProfileRepository(result: profile)
        let query = MockQueryExecutor(
            context: ReadAccountProfile(profile: repository)
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [AccountPermissions.Profile.manage]
        )
        let useCase = GetAccountProfile(authorizer: authorizer, query: query)

        _ = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(userId: profile.userId)
        )

        #expect(await repository.requestedUserIds == [profile.userId])
    }

    @Test
    func getAccountProfileDoesNotReadTargetUserWithOwnPermission() async throws {
        let profile = makeAccountProfile()
        let repository = MockAccountProfileRepository(result: profile)
        let query = MockQueryExecutor(
            context: ReadAccountProfile(profile: repository)
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [AccountPermissions.Profile.read]
        )
        let useCase = GetAccountProfile(authorizer: authorizer, query: query)

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "admin-1"),
                input: .init(userId: profile.userId)
            )
        }

        #expect(await repository.requestedUserIds.isEmpty)
        #expect(await query.runCallCount == 0)
    }

    @Test
    func editAccountProfilePersistsTargetUserWithManagePermission() async throws {
        let profile = makeAccountProfile()
        let repository = MockAccountProfileRepository(result: profile)
        let transaction = MockTransactionExecutor(
            context: WriteAccountProfile(profile: repository)
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [AccountPermissions.Profile.manage]
        )
        let useCase = EditAccountProfile(
            authorizer: authorizer,
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(
                firstName: "Grace",
                lastName: "Hopper",
                imageURL: nil,
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
    func editAccountProfileDoesNotWriteTargetUserWithOwnPermission() async throws {
        let profile = makeAccountProfile()
        let repository = MockAccountProfileRepository(result: profile)
        let transaction = MockTransactionExecutor(
            context: WriteAccountProfile(profile: repository)
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [AccountPermissions.Profile.update]
        )
        let useCase = EditAccountProfile(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "admin-1"),
                input: .init(
                    firstName: "Grace",
                    lastName: "Hopper",
                    imageURL: nil,
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
        let transaction = MockTransactionExecutor(
            context: WriteAccountProfile(profile: repository)
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [AccountPermissions.Profile.update]
        )
        let useCase = EditAccountProfile(
            authorizer: authorizer,
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: profile.userId),
            input: .init(
                firstName: "Grace",
                lastName: "Hopper",
                imageURL: "https://example.com/grace.png"
            )
        )

        #expect(result.firstName == "Grace")
        #expect(result.lastName == "Hopper")
        #expect(await repository.updateCallCount == 1)
        #expect(await repository.updatedModel?.firstName == "Grace")
        #expect(await repository.updatedModel?.lastName == "Hopper")
        #expect(await transaction.runCallCount == 1)
    }

    @Test
    func editAccountProfileDoesNotWriteWithoutPermission() async throws {
        let repository = MockAccountProfileRepository(result: makeAccountProfile())
        let transaction = MockTransactionExecutor(
            context: WriteAccountProfile(profile: repository)
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [AccountPermissions.Profile.read]
        )
        let useCase = EditAccountProfile(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "account-1"),
                input: .init(firstName: "Grace", lastName: "Hopper", imageURL: nil)
            )
        }

        #expect(await repository.updateCallCount == 0)
        #expect(await transaction.runCallCount == 0)
    }

    @Test
    func editAccountProfileDoesNotPersistInvalidNames() async throws {
        let repository = MockAccountProfileRepository(result: makeAccountProfile())
        let transaction = MockTransactionExecutor(
            context: WriteAccountProfile(profile: repository)
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [AccountPermissions.Profile.update]
        )
        let useCase = EditAccountProfile(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: AccountProfile.Error.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "account-1"),
                input: .init(
                    firstName: String(repeating: "A", count: 256),
                    lastName: "Lovelace",
                    imageURL: nil
                )
            )
        }

        #expect(await repository.updateCallCount == 0)
        #expect(await transaction.runCallCount == 1)
    }

    @Test
    func exposesAllSettingsPermissions() {
        let settingsPermissions = AccountPermissions.Settings
            .allPermissions()
        let allPermissions = AccountPermissions.allPermissions()

        #expect(
            settingsPermissions == [
                AccountPermissions.Settings.read,
                AccountPermissions.Settings.update,
                AccountPermissions.Settings.manage,
            ]
        )
        #expect(
            allPermissions == AccountPermissions.Profile.allPermissions()
                .union(settingsPermissions)
                .union(AccountPermissions.Invitations.allPermissions())
        )
    }

    @Test
    func getSettingsReadsTargetUserWithManagePermission() async throws {
        let settings = makeSettings()
        let repository = MockSettingsRepository(result: settings)
        let query = MockQueryExecutor(
            context: ReadSettings(settings: repository)
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [AccountPermissions.Settings.manage]
        )
        let useCase = GetSettings(authorizer: authorizer, query: query)

        _ = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(userId: settings.userId)
        )

        #expect(await repository.getCallCount == 1)
    }

    @Test
    func getSettingsReturnsMappedDetailForAuthorizedSubject() async throws {
        let settings = makeSettings()
        let repository = MockSettingsRepository(result: settings)
        let query = MockQueryExecutor(
            context: ReadSettings(settings: repository)
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [AccountPermissions.Settings.read]
        )
        let useCase = GetSettings(
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
        #expect(await repository.getCallCount == 1)
        #expect(await query.runCallCount == 1)
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func getSettingsDoesNotQueryForForbiddenSubject() async throws {
        let repository = MockSettingsRepository(result: makeSettings())
        let query = MockQueryExecutor(
            context: ReadSettings(settings: repository)
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [AccountPermissions.Settings.update]
        )
        let useCase = GetSettings(
            authorizer: authorizer,
            query: query
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "account-1"),
                input: .init()
            )
        }

        #expect(await repository.getCallCount == 0)
        #expect(await query.runCallCount == 0)
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func editSettingsUpdatesAndReturnsMappedDetailForAuthorizedSubject()
        async throws
    {
        let settings = makeSettings()
        let repository = MockSettingsRepository(result: settings)
        let transaction = MockTransactionExecutor(
            context: WriteSettings(settings: repository)
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [AccountPermissions.Settings.update]
        )
        let useCase = EditSettings(
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
        let repository = MockSettingsRepository(result: makeSettings())
        let transaction = MockTransactionExecutor(
            context: WriteSettings(settings: repository)
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [AccountPermissions.Settings.read]
        )
        let useCase = EditSettings(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "account-1"),
                input: .init(
                    language: "de",
                    timezone: "Europe/Berlin",
                    pageSize: 50
                )
            )
        }

        #expect(await transaction.runCallCount == 0)
        #expect(await repository.updateCallCount == 0)
        #expect(await authorizer.canCallCount == 1)
    }

    private func makeSettings() -> Settings {
        Settings(
            userId: "account-1",
            language: "en",
            timezone: "UTC",
            pageSize: 20,
            createdAt: Date(timeIntervalSince1970: 1),
            updatedAt: Date(timeIntervalSince1970: 2)
        )
    }

    private func makeAccountProfile() -> AccountProfile {
        AccountProfile(
            userId: "account-1",
            firstName: "Ada",
            lastName: "Lovelace",
            imageURL: nil,
            createdAt: Date(timeIntervalSince1970: 1),
            updatedAt: Date(timeIntervalSince1970: 2)
        )
    }
}
