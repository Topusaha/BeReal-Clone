//
//  DateFormatter.swift
//  BeRealClone
//
//  Created by Topu Saha on 3/8/24.
//



import Foundation

extension DateFormatter {
    static var postFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
}
