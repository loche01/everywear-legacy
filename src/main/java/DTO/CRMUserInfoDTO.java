//회원 상세 정보
package DTO;

public class CRMUserInfoDTO {

    private UserDTO user;                // 회원 기본 정보
    private UserAddrDTO addr;           // 기본 배송지
    private int totalOrderAmount;       // 누적 결제 금액
    private String lastLoginDate;       // 마지막 로그인 일자

    public CRMUserInfoDTO() {}

    public CRMUserInfoDTO(UserDTO user, UserAddrDTO addr, int totalOrderAmount, String lastLoginDate) {
        this.user = user;
        this.addr = addr;
        this.totalOrderAmount = totalOrderAmount;
        this.lastLoginDate = lastLoginDate;
    }

    public UserDTO getUser() {
        return user;
    }

    public void setUser(UserDTO user) {
        this.user = user;
    }

    public UserAddrDTO getAddr() {
        return addr;
    }

    public void setAddr(UserAddrDTO addr) {
        this.addr = addr;
    }

    public int getTotalOrderAmount() {
        return totalOrderAmount;
    }

    public void setTotalOrderAmount(int totalOrderAmount) {
        this.totalOrderAmount = totalOrderAmount;
    }

    public String getLastLoginDate() {
        return lastLoginDate;
    }

    public void setLastLoginDate(String lastLoginDate) {
        this.lastLoginDate = lastLoginDate;
    }
}
