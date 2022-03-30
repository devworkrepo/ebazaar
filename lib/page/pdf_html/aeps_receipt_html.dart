import 'package:number_to_words/number_to_words.dart';
import 'package:spayindia/model/report/print_receipt.dart';

String aepsReceiptHtmlPage(PrintReceipt data) {
  return """
  
  
<style>
    .modal-body {
        line-height: 21px;
    }

    .panel {
        color: #222 !important;
    }

    .modal-body p {
        line-height: 20px;
        margin-bottom: 0px;
    }

    .modalfoot {
        padding-top: 50px;
    }
   table {
  /*border-collapse: collapse;*/
  width: 100%;
}

</style>


<div id="myReciept" class="modal fade" role="dialog" data-backdrop="static" data-keyboard="false">
    <div class="modal-dialog" style="width: 900px; margin: 30px auto;">
        <div class="modal-content">
            <div class="modal-body" style="padding: 10px; border-radius: 0px;">
                <div class="col-md-12">
                    <button type="button" class="btn" data-dismiss="modal" style="padding: 6px ! important; top: -8px; right: -35px; background-color: rgb(255, 255, 255) ! important; position: absolute;">&times;</button>
                </div>
                <div class="containers" style="height: 500px; overflow: auto; width: 100%">
                    <div class="panel panel-primary">
                       
                        <div class="panel-body" style="padding: 0% 4%">
                            <div class="clearfix"></div>
                            <div class="row">
                                <div class="col-md-9"></div>
                                <div class="col-md-3">
                                   
                                </div>
                            </div>
                            <div class="clearfix"></div>
                            <div id="reciept" style="margin-top: 5px; margin-bottom: 7px;">

                                <div class="row">
                                    <div class="col-md-12" id="dvContents">
                                        <style>
                                            td {
                                                padding: 5px;
                                            }
                                        </style>
                                         <table style="width: 100%; border: 1px solid #888;" >
                                            <tr>
                                                <td> <img src="https://spayindia.com/newlog/images/Logo168.png" style="width:70px;" /></td>
                                                <td style="text-align:center"> <b>Outlet Namze:${data.shopName ?? ""}<br>Address: ${data.shopAddress ?? ""}<br>Contact Number: ${data.shopContact ?? ""}</b></td>
                                               
                                         </table>
                                        <table style="width: 100%; border: 1px solid #888;" >
                                            <tr>
                                                
                                            </tr>
                                            <tr style="border-top:1px solid #ddd;" id="trandetailbybps">
                                                <td>
                                                    <b class="cs" >Aadhaar Number : </b>
													<span id="printBillerName">	${data.accountNumber ?? ""} </span><br /> 
                                                    <b class="cs" >Bank Name : </b><span id="printConsumerNumber"> ${data.bankName ?? ""}</span><br />
                                                </td>
                                                <td>

                                                   
													<b class="cs" >Customer Mobile No :</b><span id="printCustomerNumber"> ${data.senderMobile ?? ""}</span><br />
                                                    <b class="cs" >Txn Type :</b><span id="prt_tranchannel">${data.transactionType ?? ""}</span><br />
                                                </td>
                                                <td></td>
                                            </tr>
											<tr>
                                                <td colspan="3" style="border-bottom: 1px solid #ccc; border-top: 1px solid #ccc;"><b>Transaction Details : &nbsp;&nbsp;&nbsp;&nbsp;       </b><span id="bbps_id">${data.recieptNo ?? ""}</span></td>
                                                
                                                
                                            </tr>
                                            <tr>
                                                <td colspan="3" class="nospace1">
                                                    <table class="table table-bordered" style="margin-bottom: 2px;" >
														<thead>
															<tr style="background:#ddd;">
																<td class="phead"><b>Date</b></td>
																<td class="phead"><b>Service Provider</b></td> 
																<td class="phead"><b>Transaction ID </b></td>
																<td class="phead"><b>Bank Ref </b></td>
																<td class="phead"><b>Amount </b></td>
															
																<td class="phead"><b>Status </b></td>
															</tr>
                                                        </thead>
                                                        <tbody id="printTBody">
                                                            <tr>
                                                                <td>${data.createdAt ?? ""}</td>
                                                                <td>${data.serviceProvider ?? ""}</td>
                                                                <td>${data.txnId ?? ""}</td>
                                                                <td>${data.bankRefNo ?? ""}</td>
                                                                <td>${data.amount ?? ""}</td>
                                                            
                                                                <td>${data.status ?? ""}</td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                          <tr>
                                                <td colspan="3" style="padding: 0px;" >                                                   
                                                    <div class="cs col-md-12 col-sm-12 col-xs-12">
                                                        <b>Total Amount Rs. : </b>
                                                        <label id="printAmount">${data.amount ?? ""}</label>&nbsp;&nbsp;&nbsp;
                                                    </div>
                                                    <div class="cs col-md-12 col-sm-12 col-xs-12">
                                                        <b>Amount in Words :</b>
                                                        <label id="prt_tranword">
                                                            ${(NumberToWord().convert("en-in", (data.amount ?? 0) )).toUpperCase()}  Rupees Only/- 
                                                        </label>
                                                    </div>
                                                </td>
                                            </tr>  
                                             <tr>
                                                   <td colspan="3" style="padding: 0px 8px;" >                
                                                    <b>Disclaimer :</b>
                                                    <p style="margin: 0 0 0px !important; font-size: 12px">This is a system generated Receipt. Hence no seal or signature required.</p>
                                                   
                                                    <p style="margin: 0 0 0px !important; font-size: 12px">
													spayindia Technologies Group 56, Ganesh Nagar-5, Nadi Ka Phatak, Murlipura, Jaipur</p>
                                                    <p style="margin: 0 0 0px !important; font-size: 12px">GST Identification Number - 08ABZPA6377J1ZX</p>
                                                    <p style="margin: 0 0 0px !important; font-size: 12px">HelpLine No : 9950007764/65, 9950207766 </p>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3" class="modalfoot" style="text-align: center; padding: 0px;" >
                                                    <p style="margin: 0 0 0px !important;" >&copy; 2021 All Rights Reserved</p>
                                                  
                                                </td>
                                            </tr>
                                         
                                        </table> 
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>  


 """;
}
