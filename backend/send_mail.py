import smtplib
from email.mime.text import MIMEText


def send(sender_email, message):
    email = "giftjob2021@gmail.com"
    password = "Giftjobr#qpl"
    msg = MIMEText(message.encode("utf-8"), "plain", "UTF-8")
    msg["Subject"] = "Barmajet - Contact Us"
    msg["From"] = email
    msg["To"] = sender_email
    msg["Cc"] = ""
    msg["Reply-to"] = sender_email
    try:
        smtp_server = smtplib.SMTP_SSL("smtp.gmail.com", 465)
        smtp_server.ehlo()
        smtp_server.login(email, password)
        smtp_server.send_message(msg)
        smtp_server.close()
    except:
        pass
