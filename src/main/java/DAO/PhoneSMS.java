package DAO;

import java.text.DecimalFormat;
import java.util.HashMap;

import org.json.simple.JSONObject;

import net.nurigo.java_sdk.api.Message;
import net.nurigo.java_sdk.exceptions.CoolsmsException;

public class PhoneSMS {

	public static void sendVerification(String phone, String code) throws CoolsmsException {
		if (phone == null || !phone.matches("010[0-9]{8}") || code == null || !code.matches("[0-9]{6}"))
			throw new IllegalArgumentException("Invalid verification request.");
		Message client = new Message(requiredConfig("EVERYWEAR_SMS_API_KEY"), requiredConfig("EVERYWEAR_SMS_API_SECRET"));
		HashMap<String, String> params = new HashMap<>();
		params.put("to", phone);
		params.put("from", requiredConfig("EVERYWEAR_SMS_SENDER"));
		params.put("type", "SMS");
		params.put("text", "[everyWEAR] 인증번호는 [" + code + "]입니다.");
		JSONObject result = (JSONObject) client.send(params);
		if (result == null || !"1".equals(String.valueOf(result.get("success_count"))))
			throw new IllegalStateException("Verification delivery failed.");
	}

	private static String requiredConfig(String name) {
		String value = System.getenv(name);
		if (value == null || value.isBlank()) {
			value = System.getProperty(name);
		}
		if (value == null || value.isBlank()) {
			throw new IllegalStateException(name + " environment variable or system property is required");
		}
		return value;
	}

	// legacy sendSMS(String) 는 코드를 호출자에게 돌려주고 발송 실패를 삼켰다.
	// 본인확인 발송은 전부 위 sendVerification(phone, code) 으로 일원화한다.

	public static void sendMSG(String phone, String Products, String price) {
		
		//발급받은 key, secret 작성
		String api_key = requiredConfig("EVERYWEAR_SMS_API_KEY");
		String api_secret = requiredConfig("EVERYWEAR_SMS_API_SECRET");
		
		DecimalFormat formatter = new DecimalFormat("#,###");
		
		Message coolsms = new Message(api_key, api_secret);
		
		HashMap<String, String> params = new HashMap<String, String>();
		
		String cleanedPhone = phone.replaceAll("-", "");
		
		params.put("to", cleanedPhone);			//송신자 번호('-' 없이 작성)
		params.put("from", requiredConfig("EVERYWEAR_SMS_SENDER"));			//발송자 번호('-' 작성)
		params.put("type", "SMS");
		
		//보낼 메세지 작성
		params.put("text", "[everyWEAR 알림]" + "\n" + Products + "\n" + "총 " + formatter.format(Integer.parseInt(price)) + "원이 결제되었습니다.");
		params.put("app_version", "test app 1.2");
		
		try {
			JSONObject obj =(JSONObject) coolsms.send(params);
			System.out.println(obj.toString());
		}
		catch(CoolsmsException e) {
			System.out.println(e.getMessage());
			System.out.println(e.getCode());
		}
	}
}
