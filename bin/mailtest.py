import sys
def send_email(TO, SUBJECT, TEXT):
    import smtplib
    
    if len(sys.argv) > 1:
        user = sys.argv[1]
        pwd = sys.argv[2]
        if len(sys.argv) > 3:
            server_name = sys.argv[3]
        else:
            server_name = 'sendgrid'
    else:
        server_name='smtp'
    FROM = "no-reply@bawkbox.com"
    print('server is ', server_name)
    # Prepare actual message
    message = """From: %s\nTo: %s\nSubject: %s\n\n%s
    """ % (FROM, ", ".join(TO), SUBJECT, TEXT)
    if server_name == "aws":
        server = smtplib.SMTP("email-smtp.ca-central-1.amazonaws.com", 587)
    elif server_name == 'sendgrid':
        server = smtplib.SMTP("smtp.sendgrid.net", 587)
    elif server_name == 'blue':
        server = smtplib.SMTP("smtp-relay.sendinblue.com", 587)
    else:
        server = smtplib.SMTP(server_name)
    server.ehlo()
    if len(sys.argv) > 1:
        server.starttls()
        server.login(user, pwd)
    server.sendmail(FROM, TO, message)
    server.close()

send_email(['clark@countable.ca'], 'test mail', 'hello. this is the body.')

