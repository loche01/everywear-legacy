package DAO;

import java.util.Properties;

import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class GmailSend {

	public static void sendVerification(String email, String code) throws javax.mail.MessagingException {
		sendVerification(email, code, "[everyWEAR] 비밀번호 재설정 인증번호");
	}

	// 제목은 호출부의 서버측 상수만 받는다. 본문에는 사용자 입력을 넣지 않는다.
	public static void sendVerification(String email, String code, String subject) throws javax.mail.MessagingException {
		Properties properties = new Properties();
		properties.setProperty("mail.smtp.host", "smtp.gmail.com");
		properties.setProperty("mail.smtp.port", "587");
		properties.setProperty("mail.smtp.auth", "true");
		properties.setProperty("mail.smtp.starttls.enable", "true");
		properties.setProperty("mail.smtp.starttls.required", "true");
		// JavaMail 1.4.6 기본값(TLSv1)은 Java 21에서 비활성화되어 STARTTLS 핸드셰이크가 실패한다.
		properties.setProperty("mail.smtp.ssl.protocols", "TLSv1.2");
		properties.setProperty("mail.smtp.connectiontimeout", "10000");
		properties.setProperty("mail.smtp.timeout", "10000");
		Session mailSession = Session.getInstance(properties, new SMTPAuthenticator());
		mailSession.setDebug(false);
		MimeMessage message = new MimeMessage(mailSession);
		message.setFrom(new InternetAddress(requireConfig("EVERYWEAR_SMTP_USER")));
		message.setRecipient(Message.RecipientType.TO, new InternetAddress(email, true));
		message.setSubject(subject, "UTF-8");
		message.setText("인증번호: " + code + "\n5분 안에 입력해주세요.", "UTF-8");
		Transport.send(message);
	}

	private static String requireConfig(String name) {
		String value = System.getenv(name);
		if (value == null || value.isBlank()) {
			value = System.getProperty(name);
		}
		if (value == null || value.isBlank()) {
			throw new IllegalStateException(name + " environment variable or system property is required");
		}
		return value;
	}
	
	private static class SMTPAuthenticator extends Authenticator {
		public PasswordAuthentication getPasswordAuthentication() {
			return new PasswordAuthentication(requireConfig("EVERYWEAR_SMTP_USER"), requireConfig("EVERYWEAR_SMTP_PASSWORD"));
		}
	}
	public static void send(String title, String content, String toEmail) {
		Properties p = new Properties();

		p.put("mail.smtp.starttls.enable", "true");
		// 이메일 발송을 처리해줄 SMTP서버
		p.put("mail.smtp.host", "smtp.gmail.com");
		// SMTP 서버의 인증을 사용한다는 의미
		p.put("mail.smtp.auth", "true");
		// TLS의 포트번호는 587이며 SSL의 포트번호는 465이다.
		p.put("mail.smtp.port", "587");
		// soket문제와 protocol문제 해결
		p.put("mail.smtp.ssl.trust", "smtp.gmail.com");
		p.put("mail.smtp.socketFactory.fallback", "false");
		p.put("mail.smtp.ssl.protocols", "TLSv1.2");
		
		try {
			Authenticator auth = new SMTPAuthenticator();
			Session session = Session.getInstance(p, auth);
			session.setDebug(false); 
			MimeMessage msg = new MimeMessage(session);
			String message = content;
			msg.setSubject(title);
			Address fromAddr = new InternetAddress(requireConfig("EVERYWEAR_SMTP_USER")); 
			msg.setFrom(fromAddr);
			Address toAddr = new InternetAddress(toEmail); 
			msg.addRecipient(Message.RecipientType.TO, toAddr);
			msg.setContent(message, "text/html;charset=KSC5601");
			Transport.send(msg);
		} catch (Exception e) { 
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args) {
		String title = "제목";
		String content = "내용";
		String toEmail = "보낼 이메일";
		GmailSend.send(title, content, toEmail);
		System.out.println("성공~~~~~~");
	}
}







