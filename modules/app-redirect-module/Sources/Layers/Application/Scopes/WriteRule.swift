//
//  WriteRule.swift
//  app-redirect-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import RedirectDomain

public struct WriteRule: Scope {
    public let rule: any RuleRepository

    public init(rule: any RuleRepository) {
        self.rule = rule
    }
}
