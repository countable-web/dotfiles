import sys
def send_email():
    import smtplib

    user = sys.argv[1]
    pwd = sys.argv[2]
    if len(sys.argv) > 3:
        server_name = sys.argv[3]
    else:
        server_name = 'sendgrid'
    FROM = "no-reply@bawkbox.com"
    TO = ["clark@countable.ca"]
    SUBJECT = "hello"
    TEXT = "hi"

    # Prepare actual message
    message = """From: %s\nTo: %s\nSubject: %s\n\n%s
    """ % (FROM, ", ".join(TO), SUBJECT, TEXT)
    if server_name == "aws":
        server = smtplib.SMTP("email-smtp.ca-central-1.amazonaws.com", 587)
    elif server_name == 'sendgrid':
        server = smtplib.SMTP("smtp.sendgrid.net", 587)
    else:
        server = server_name
    server.ehlo()
    server.starttls()
    server.login(user, pwd)
    server.sendmail(FROM, TO, message)
    server.close()

send_email()

