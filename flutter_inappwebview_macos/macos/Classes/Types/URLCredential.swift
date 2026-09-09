//
//  URLCredential.swift
//  flutter_inappwebview
//
//  Created by Lorenzo Pichilli on 19/02/21.
//

import Foundation

extension URLCredential {
    public func toMap () -> [String:Any?] {
        var x509Certificates: [Data] = []
        for certificate in certificates {
            if let secCert = certificate as? SecCertificate {
                x509Certificates.append(secCert.data)
            }
        }
        return [
            "password": password,
            "username": user,
            "certificates": x509Certificates,
            "persistence": persistence.rawValue
        ]
    }
}
