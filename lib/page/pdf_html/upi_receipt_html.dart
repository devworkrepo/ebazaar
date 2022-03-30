import 'package:number_to_words/number_to_words.dart';
import 'package:spayindia/model/report/print_receipt.dart';

String upiReceiptHtmlPage(PrintReceipt data, int commissionAmount){
  return """
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
                            <div id="reciept">

                                <div class="row">
                                    <div class="col-md-12" id="dvContents">
                                        
                                         <table style="width: 100%;font-size: 15px;border: 1px solid black; border-collapse: collapse;">
                                            <tr>
                                                <td> <img src="https://spayindia.com/newlog/images/Logo168.png" style="width:70px;" /></td>
                                                <td style="text-align:center"> <b>Outlet Name:${data.shopName ?? ""}</b><br>Address: ${ data.shopAddress }<br>Contact Number: ${data.shopContact ?? ""}</td>
                                                
                                         </table>
                                        <table style="width: 100%;font-size: 15px;border: 1px solid black; border-collapse: collapse;" >
                                            
                                            <tr style="" id="trandetailbybps">
                                                <td>
                                                    <b class="cs" > UPI ID :</b><span >${data.accountNumber ?? ""}</span><br />
                                                    <b class="cs" > Bene Name :</b><span >${data.beneficiaryName ?? ""}</span><br />
                                                  
                                                   
                                                </td>
                                                <td>
                                                 
                                                 
                                                    <b class="cs" > Transaction Type :</b>
                                                    <span>${data.transactionType ?? ""}</span><br/>
                                                     <b class="cs" > Wallet Name :</b>
                                                    <span>${data.walletName ?? ""}</span><br/>
													
                                                </td>
                                                <td> <b class="cs" > Sender Number :</b>
                                                    <span>${data.senderMobile ?? ""}</span><br/>
                                                    <b class="cs" > Sender Name :</b>
                                                    <span>${data.senderName ?? ""}</span><br/></td>
                                            </tr>
											<tr>
                                                <td colspan="3" style="border-bottom: 1px solid #ccc; border-top: 1px solid #ccc;"><b>Transaction Details&nbsp;&nbsp;&nbsp;&nbsp;       </b><span id="bbps_id"></span>${data.recieptNo ?? ""}</td>
                                                
                                            </tr>
                                            <tr>
                                                <td colspan="3" class="nospace1">
                                                    <table class="table table-bordered" style="width:100%;font-size:15px;border: 1px solid black;" >
														<thead>
				<tr style="background:#ddd;border: 1px solid black;">
				<td class="phead" style=""><b>Date</b></td>
				<td class="phead" style=""><b>Transaction ID </b></td>
				<td class="phead" style=""><b>Bank Ref </b></td>
				<td class="phead" style=""><b>Amount </b></td>
				<td class="phead" style=""><b>Status </b></td>
				</tr>
                                                        </thead>
                                                        <tbody id="printTBody">
                                                          
                                                     
                                                         <tr style="">
                                        <td style=""><span id="prt_trandate"></span>${data.createdAt ?? ""}</td>
                                       
                                        <td style=""><span id="prt_tranid">${data.txnId ?? ""}</span></td>
                                        <td style=""><span id="prt_tranrefernce">${data.bankRefNo ?? ""}</span></td>
                                        <td style=""><span id="prt_tranamount">${data.amount ?? ""}</span></td>
                                        <td style=""><span id="prt_transtatus" class="status_1">${data.status ?? ""}</span></td>
									
                                                        </tr>
                                                      
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                          <tr>
                                                <td colspan="3" style="padding-top: 5px;" >                                                   
                                                    <div class="cs col-md-12" style="font-size:13px">
                                                       
                                                        <b>Total Amount Rs. : ${(data.amount ?? 0) + commissionAmount}</b>
                                        
                                                        <br>
                                                            <b>Amount in Words :</b>
                                                            <label id="prt_tranword">${(NumberToWord().convert("en-in", (data.amount ?? 0) + commissionAmount)).toUpperCase() }  Rupees Only/-</label>
                                                       
                                                    </div>
                                                </td>
                                            </tr>  
                                             <tr>
                                                   <td colspan="3" style="padding: 0px 8px;" >                
                                                    <b>Disclaimer :</b>
                                                    <p style="margin: 0 0 0px !important; font-size: 12px">This is a system generated receipt, hence no seal or signature is required.</p>
                                                   
                                                    <p style="margin: 0 0 0px !important; font-size: 12px">
													spayindia Technologies Group <br>56, Ganesh Nagar-5, Nadi Ka Phatak, Murlipura, Jaipur</p>
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