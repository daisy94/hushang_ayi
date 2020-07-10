package utils;

//异常信息枚举类
public enum InfoCode {

    LOGIN_FAIL(100, "用户名或密码错误啦！"),
    SAVE_SUCCESS(0, "保存成功"),
    SAVE_FAIL(150, "保存失败");

    public final int code;
    public final String msg;

    InfoCode (int code, String msg){
        this.code = code;
        this.msg = msg;
    }
}