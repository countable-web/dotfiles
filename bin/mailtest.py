def send_email():
    import smtplib

    gmail_user = sys.argv[1]
    gmail_pwd = sys.argv[2]
    FROM = "clark@countableclient.local"
    TO = ["clark@countable.ca"]
    SUBJECT = "hello"
    TEXT = "hi"

    # Prepare actual message
    message = """From: %s\nTo: %s\nSubject: %s\n\n%s
    """ % (FROM, ", ".join(TO), SUBJECT, TEXT)
    server = smtplib.SMTP("smtp.sendgrid.net", 587)
    server.ehlo()
    server.starttls()
    server.login(gmail_user, gmail_pwd)
    server.sendmail(FROM, TO, message)
    server.close()

send_email()

