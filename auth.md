## OAuth/2, OpenID, etc
- OAuth/2 should be used in conjunction with OpenID
- Do not use OAuth/2 itself for authentication (use OpenID Connect instead)
- Use state parameter to prevent CSRF attacks
- OpenID Connect is a stack on top of OAuth

```
OpenID is about verifying a person's identity.
OAuth is about accessing a person's stuff.
OpenID Connect does both.
```

### Checklist
* [No Cleartext Storage of Credentials](https://tools.ietf.org/html/rfc6819#section-5.1.4.1.3)
* [Encryption of Credentials](https://tools.ietf.org/html/rfc6819#section-5.1.4.1.4)
* [Use Short Expiration Time](https://tools.ietf.org/html/rfc6819#section-5.1.5.3)
* [Limit Number of Usages or One-Time Usage](https://tools.ietf.org/html/rfc6819#section-5.1.5.4)
* [Bind Token to Client id](https://tools.ietf.org/html/rfc6819#section-5.1.5.8)
* [Automatic Revocation of Derived Tokens If Abuse Is Detected](https://tools.ietf.org/html/rfc6819#section-5.2.1.1)
* [Binding of Refresh Token to "client_id"](https://tools.ietf.org/html/rfc6819#section-5.2.2.2)
* [Refresh Token Rotation](https://tools.ietf.org/html/rfc6819#section-5.2.2.3)
* [Revocation of Refresh Tokens](https://tools.ietf.org/html/rfc6819#section-5.2.2.4)
* [Validate Pre-Registered "redirect_uri"](https://tools.ietf.org/html/rfc6819#section-5.2.3.5)
* [Binding of Authorization "code" to "client_id"](https://tools.ietf.org/html/rfc6819#section-5.2.4.4)
* [Binding of Authorization "code" to "redirect_uri"](https://tools.ietf.org/html/rfc6819#section-5.2.4.6)
* [Opaque access tokens](https://tools.ietf.org/html/rfc6749#section-1.4)
* [Opaque refresh tokens](https://tools.ietf.org/html/rfc6749#section-1.5)
* [Ensure Confidentiality of Requests](https://tools.ietf.org/html/rfc6819#section-5.1.1)
* [Use of Asymmetric Cryptography](https://tools.ietf.org/html/rfc6819#section-5.1.4.1.5)

*Stolen from https://github.com/ory/fosite*




### Videos
- https://www.youtube.com/watch?v=GyCL8AJUhww
- https://www.youtube.com/watch?v=aIFRvSxIZ0k
- https://www.youtube.com/watch?v=996OiexHze0


### Links
- https://github.com/snyff/oauthsecurity
- https://openidconnect.net/
- https://hueniverse.com/oauth-2-0-and-the-road-to-hell-8eec45921529
- https://security.stackexchange.com/questions/44611/difference-between-oauth-openid-and-openid-connect-in-very-simple-term
- https://remysharp.com/2007/12/21/how-to-integrate-openid-as-your-login-system
- https://www.owasp.org/images/9/99/Helsinki_meeting_30_-_Threats_and_Vulnerabilities_in_Federation_Protocols_and_Products.pdf
- https://www.theregister.co.uk/2016/01/08/good_news_oauth_is_ialmosti_secure/
- https://wiki.mozilla.org/Security/Guidelines/OpenID_connect
- https://nordicapis.com/api-security-oauth-openid-connect-depth/
- https://oauth.net/2/
- https://tools.ietf.org/html/rfc6819#section-5.1.5.4
- https://brockallen.com/2019/01/03/the-state-of-the-implicit-flow-in-oauth2/
- https://medium.com/securing/what-is-going-on-with-oauth-2-0-and-why-you-should-not-use-it-for-authentication-5f47597b2611
- https://aaronparecki.com/oauth-2-simplified/#authorization
- https://www.theidentitycookbook.com/2016/10/protect-bearer-tokens-using-proof-of.html
- https://connect2id.com/learn/token-binding
- https://infosec.mozilla.org/guidelines/iam/openid_connect.html
- https://www.pingidentity.com/en/company/blog/posts/2019/jwt-security-nobody-talks-about.html
