//
//  WriteInvitation.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import AuthDomain
public import AccountDomain
public import FeatherContracts
public import UserDomain

public struct WriteInvitation: Scope {
    public let invitation: any InvitationRepository
    public let identity: any IdentityRepository
    public let role: any RoleRepository
    public let authEmail: any AuthEmailRepository
    public let credential: any InvitationCredentialWriter

    public init(
        invitation: any InvitationRepository,
        identity: any IdentityRepository,
        role: any RoleRepository,
        authEmail: any AuthEmailRepository,
        credential: any InvitationCredentialWriter
    ) {
        self.invitation = invitation
        self.identity = identity
        self.role = role
        self.authEmail = authEmail
        self.credential = credential
    }
}
