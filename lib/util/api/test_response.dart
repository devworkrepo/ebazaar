class TestResponse {
  TestResponse._();

  static dynamic commonSuccessResponse() {
    return {"status": "Success", "code": 1, "message": "Success"};
  }

  static dynamic getCaptchaCommonResponse() {
    return {"status": "Success",
      "code": 1,
      "message": "validation success",
      "captcha_img" : "https://static.hindawi.com/articles/scn/volume-2017/6898617/figures/6898617.fig.008b.jpg",
      "uuid" : "13123123"
    };
  }
}
