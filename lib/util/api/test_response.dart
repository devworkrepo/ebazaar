class TestResponse {
  TestResponse._();

  static dynamic commonSuccessResponse() {
    return {
      "status": "Success",
      "code": 1,
      "message": "Success",
      "intamt" : 1000,
      "intrate" : 11,
      "matureamt" : 14000,
      "maturedate" : "01-01-2024",
    };
  }

  static dynamic closeCalcResponse() {
    return {
      "status": "Success",
      "code": 1,
      "message": "Success",
      "balance" : "10000",
      "charges" : "120",
      "closetype" : "Early",
      "trans_no" : "12313123123",
    };
  }

  static dynamic investmentListResponse() {
    return {
      "status": "Success",
      "code": 1,
      "message": "Success",
      "totalcount" : "1",
      "totalamt" : "100" ,
      "total_int" : "12",
      "total_withamt" : "12312" ,
      "total_matuamt" : "2312",
      "translist" : [
        {
          "fdid" : "hello dev" ,
          "fd_refno" : "hello dev" ,
          "pan_no" : "hello dev" ,
          "amount" : "hello dev" ,
          "tenure_value" : "hello dev" ,
          "tenure_type" : "hello dev" ,
          "int_rate" : "hello dev" ,
          "int_earned" : "hello dev" ,
          "current_amount" : "hello dev" ,
          "mature_amount" : "hello dev" ,
          "addeddate" : "hello dev" ,
          "completedate" : "hello dev" ,
          "closeddate" : "hello dev" ,
          "closedtype" : "hello dev" ,
          "trans_status" : "hello dev" ,
          "trans_response" : "hello dev" ,
          "pay_status" : "hello dev" ,
          "isclosebtn" : "hello dev" ,
        },
        {
          "fdid" : "hello dev" ,
          "fd_refno" : "hello dev" ,
          "pan_no" : "hello dev" ,
          "amount" : "hello dev" ,
          "tenure_value" : "hello dev" ,
          "tenure_type" : "hello dev" ,
          "int_rate" : "hello dev" ,
          "int_earned" : "hello dev" ,
          "current_amount" : "hello dev" ,
          "mature_amount" : "hello dev" ,
          "addeddate" : "hello dev" ,
          "completedate" : "hello dev" ,
          "closeddate" : "hello dev" ,
          "closedtype" : "hello dev" ,
          "trans_status" : "hello dev" ,
          "trans_response" : "hello dev" ,
          "pay_status" : "hello dev" ,
          "isclosebtn" : "hello dev" ,
        },
        {
          "fdid" : "hello dev" ,
          "fd_refno" : "hello dev" ,
          "pan_no" : "hello dev" ,
          "amount" : "hello dev" ,
          "tenure_value" : "hello dev" ,
          "tenure_type" : "hello dev" ,
          "int_rate" : "hello dev" ,
          "int_earned" : "hello dev" ,
          "current_amount" : "hello dev" ,
          "mature_amount" : "hello dev" ,
          "addeddate" : "hello dev" ,
          "completedate" : "hello dev" ,
          "closeddate" : "hello dev" ,
          "closedtype" : "hello dev" ,
          "trans_status" : "hello dev" ,
          "trans_response" : "hello dev" ,
          "pay_status" : "hello dev" ,
          "isclosebtn" : "hello dev" ,
        },
        {
          "fdid" : "hello dev" ,
          "fd_refno" : "hello dev" ,
          "pan_no" : "hello dev" ,
          "amount" : "hello dev" ,
          "tenure_value" : "hello dev" ,
          "tenure_type" : "hello dev" ,
          "int_rate" : "hello dev" ,
          "int_earned" : "hello dev" ,
          "current_amount" : "hello dev" ,
          "mature_amount" : "hello dev" ,
          "addeddate" : "hello dev" ,
          "completedate" : "hello dev" ,
          "closeddate" : "hello dev" ,
          "closedtype" : "hello dev" ,
          "trans_status" : "hello dev" ,
          "trans_response" : "hello dev" ,
          "pay_status" : "hello dev" ,
          "isclosebtn" : "hello dev" ,
        }
      ] ,
    };
  }

  static dynamic investmentStatement() {
    return {
      "code" : 1,
      "status" : "Success",
      "message" : "Data found",
      "totalcr" : "1000",
      "totaldr" : "1000",
      "balance" : "1000",
      "words" : "ten thousands only",
      "fdrefno" : "123123123",
      "openamt" : "1000",
      "matureamt" : "1000",
      "roi" : "10",
      "opendate" : "12/12/2026",
      "completedate" : "12/12/2054",
      "tenure" : "3 Years",
      "translist" : [
        {
          "date" : "12/12/1202",
          "narration" : "Testing data",
          "remark" : "Testing remark",
          "in_amt" : "0",
          "out_amt" : "20",
          "in_charge" : "20",
          "out_charge" : "10",
          "in_comm" : "100",
          "out_comm" : "200",
          "in_tds" : "500",
          "out_tds" : "350",
          "balance" : "1000",
        }
      ] ,
    };
  }

  static dynamic investmentWithdrawnList() {
    return {
      "code" : 1,
      "status" : "Success",
      "message" : "Data found",
      "translist" : [
        {
          "trfid" : "2313123",
          "fd_refno" : "1231323123213",
          "trans_no" : "24242424",
          "acc_name" : "HDFC Bank",
          "acc_no" : "893748297482",
          "ifsc" : "HDFC0000718",
          "amount" : "10000",
          "charge" : "120",
          "utr_no" : "9329837483",
          "remark" : "Testing transaction",
          "addeddate" : "12/12/2022",
          "trans_status" : "Success",
          "trans_response" : "Success",
        }
      ] ,
    };
  }
  static dynamic aadhaarDetail() {
    return
        {
          "code" : 1,
          "status" : "asdf",
          "message" : "asd",
          "picname" : "ads",
          "name" : "ad",
          "dob" : "ad",
          "gender" : "ad",
          "address" : "dlfjaslkfj klajsdfklla sjfkls j;dfkajsf",
          "aadharno" : "adfjakslkjf ajsdfklasj fksaj fksajfklasj fkl",

    };
  }

}
