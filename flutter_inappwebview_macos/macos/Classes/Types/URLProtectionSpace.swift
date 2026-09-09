//
//  URLProtectionSpace.swift
//  flutter_inappwebview
//
//  Created by Lorenzo Pichilli on 19/02/21.
//

import Foundation

extension URLProtectionSpace {
    
    var x509Certificate: Data? {
        guard let serverTrust = serverTrust else {
            return nil
        }

        var error: CFError?
        _ = SecTrustEvaluateWithError(serverTrust, &error)

        if #available(macOS 12.0, *) {
            guard let chain = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate],
                  let serverCertificate = chain.first else {
                return nil
            }
            return serverCertificate.data
        } else if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
            return serverCertificate.data
        }
        return nil
    }
    
    var sslCertificate: SslCertificate? {
        var sslCertificate: SslCertificate? = nil
        if let x509Certificate = x509Certificate {
            sslCertificate = SslCertificate(x509Certificate: x509Certificate)
        }
        return sslCertificate
    }
    
    var sslError: SslError? {
        guard let serverTrust = serverTrust else {
            return nil
        }

        var error: CFError?
        let trusted = SecTrustEvaluateWithError(serverTrust, &error)
        if trusted {
            return nil
        }

        var secResult = SecTrustResultType.invalid
        SecTrustGetTrustResult(serverTrust, &secResult)
        guard secResult != SecTrustResultType.proceed else {
            return nil
        }
        return SslError(errorType: secResult)
    }
    
    public func toMap () -> [String:Any?] {
        return [
            "host": host,
            "protocol": self.protocol,
            "realm": realm,
            "port": port,
            "sslCertificate": sslCertificate?.toMap(),
            "sslError": sslError?.toMap(),
            "authenticationMethod": authenticationMethod,
            "distinguishedNames": distinguishedNames,
            "receivesCredentialSecurely": receivesCredentialSecurely,
            "proxyType": proxyType
        ]
    }
}
