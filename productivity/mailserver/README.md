# Mail Server
A dockerized mail server for PWS. For now I am using [Stalwart](https://stalw.art/).

# Setup

1. Port forward the following ports:
- 25/TCP - SMTP, mandatory for receiving mail. May need to open a support ticket to open this port or live with partial nonfunction.
- 465 - SMTPS, implicit TLS.
- 587 - SMTP, alternative, possibly blocked by ISPs.
- 993 - IMAPS, mandatory for reading mail from apps.
- 443 - HTTPS, mandatory for the management dashboard and modern JMAP.

2. DNS Records (Basic)
- A, `Host=mail, v=YOUR_IP`
- MX, `Host=@, v=mail.example.com`
- CNAME, `em123.example.com -> sendgrid.net`
- CNAME, `s1._domainkey.example.com`
- CNAME, `s2._domainkey.example.com`

3. DNS Records (Security)
- TXT (DKIM), `Host=@, v=spf1 mx include:sendgrid.net -all`.
- TXT (DMARC), `Host=_dmarc, v=DMARC1; p=quarantine; rua=mailto:admin@example.com`, Tells people what to do if SPF/DKIM fails.

4. Configure Sendgrid/Get API Key
- We are NOT setting a PTR record because I am on a residential internet connection. 
- Set up a SendGrid account.
- Go to `Settings > API Keys` and create a key with `Full Access` and `Mail Send` permissions. Copy the key. 
- Go to `Settings > Sender Authentication` and complete Sender Authentication steps to link your domain to SendGrid so they can send your mail.

5. Create Relay Host in Stalwart (`Settings > SMTP > Outbound > Relay Hosts`)
- `Description: SendGrid Relay`
- `Address: smtp.sendgrid.net`
- `Port: 587`
- `Protocol: SMTP`
- `Authentication: Username: apikey, Secret: <YOUR_SENDGRID_API_KEY>`.

6. Set Routing Rule in Stalwart (`Settings > SMTP > Outbound > Routing')
- Create or Edit the routing strategy:
```json
[
  { "if": "is_local_domain('', rcpt_domain)", "then": "local" },
  { "else": "SendGrid Relay" }
]
```

3. Start via Docker
```bash
docker compose up -d
```

4. Test
Use [Mail-Tester.com](https://mail-tester.com) to test.
