## BackEndSecurity101

SSL / Certificate Pinning for iOS

TrustKit, an open-source SSL pinning library for iOS and macOS is available at https://github.com/datatheorem/TrustKit. It provides an easy-to-use API for implementing pinning, and has been deployed in many apps.

Otherwise, more details regarding how SSL validation can be customized on iOS (in order to implement pinning) are available in the "HTTPS Server Trust Evaluation" technical note at https://developer.apple.com/library/content/technotes/tn2232/_index.html. However, implementing pinning validation from scratch should be avoided, as implementation mistakes are extremely likely and usually lead to severe vulnerabilities.



What Is Pinning?

Pinning is the process of associating a host with their expected X509 certificate or public key. Once a certificate or public key is known or seen for a host, the certificate or public key is associated or 'pinned' to the host. If more than one certificate or public key is acceptable, then the program holds a pinset .


What is digital certificate?

A digital certificate is like an electronic passport for exchanging secure information over the Internet using the public key infrastructure (PKI).

Digital Certificates are a means by which consumers and businesses can utilise the security applications of Public Key Infrastructure (PKI). PKI comprises of the technology to enables secure e-commerce and Internet based communication.


What is the difference between a digital signature and a digital certificate?

A digital signature is a mechanism that is used to verify that a particular digital document or a message is authentic whereas A digital certificate is a certificate issued by a trusted third party called a Certificate Authority (CA) to verify the identity of the certificate holder.


Who can issue a digital certificate?

A Digital certificate is issued by a trusted third party to establish the identity of the ID holder. The third party who issues certificates is known as a Certification Authority (CA). Digital certificate technology is based on public key cryptography.



REF:
OWASP
https://www.owasp.org/index.php/Certificate_and_Public_Key_Pinning

