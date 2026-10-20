//
//  WriteInvitation.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import AuthDomain
public import AccountDomain
public import FeatherModuleKit
public import UserDomain

public struct WriteInvitation: Scope {
    public let invitation: any InvitationRepository
    public let identity: any Identity.Repository.Interface
    public let role: any Role.Repository.Interface
    public let authEmail: any AuthEmailRepository
    public let credential: any InvitationCredentialWriter

    public init(
        invitation: any InvitationRepository,
        identity: any Identity.Repository.Interface,
        role: any Role.Repository.Interface,
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
