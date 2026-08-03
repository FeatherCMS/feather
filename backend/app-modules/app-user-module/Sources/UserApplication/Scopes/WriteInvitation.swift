//
//  WriteInvitation.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AccountDomain
import Application
import UserDomain

public struct WriteInvitation: Scope {
    public let invitation: any InvitationRepository
    public let account: any AccountRepository
    public let role: any RoleRepository
    public let settings: any AccountSettingsRepository

    public init(
        invitation: any InvitationRepository,
        account: any AccountRepository,
        role: any RoleRepository,
        settings: any AccountSettingsRepository
    ) {
        self.invitation = invitation
        self.account = account
        self.role = role
        self.settings = settings
    }
}
