//
//  WriteInvitation.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import UserDomain

public struct WriteInvitation: Scope {
    public let invitation: any InvitationRepository
    public let account: any AccountRepository
    public let role: any RoleRepository
    public let hooks: any HookDispatcher

    public init(
        invitation: any InvitationRepository,
        account: any AccountRepository,
        role: any RoleRepository,
        hooks: any HookDispatcher
    ) {
        self.invitation = invitation
        self.account = account
        self.role = role
        self.hooks = hooks
    }
}
