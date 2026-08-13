//
//  WriteInvitation.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AccountDomain
import FeatherApplication
import FeatherContracts
import UserDomain

public struct WriteInvitation: Scope {
    public let invitation: any InvitationRepository
    public let identity: any IdentityRepository
    public let role: any RoleRepository

    public init(
        invitation: any InvitationRepository,
        identity: any IdentityRepository,
        role: any RoleRepository
    ) {
        self.invitation = invitation
        self.identity = identity
        self.role = role
    }
}
